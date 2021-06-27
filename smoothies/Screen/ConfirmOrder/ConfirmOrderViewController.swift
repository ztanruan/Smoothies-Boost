//
//  ConfirmOrderViewController.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 4/23/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit
import RxSwift
import Stripe

class ConfirmOrderViewController: BaseViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  private var viewModel: ConfirmOrderViewModelType!

  internal static func instantiate(viewModel: ConfirmOrderViewModel) -> ConfirmOrderViewController {
    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConfirmOrderViewController") as! ConfirmOrderViewController
    vc.viewModel = viewModel
    return vc
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Confirm order"
    setupLeftBarButton()
    setupTableView()
    setupObservable()
    viewModel.getListPaymentSources()
  }
  
  private func setupLeftBarButton() {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(named: "icon_back"), for: .normal)
    button.addTarget(self, action: #selector(backToVC), for: .touchUpInside)
    button.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
    button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 20)
    let barButton = UIBarButtonItem(customView: button)
    navigationItem.leftBarButtonItem = barButton
  }
  
  @objc func backToVC(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
  func setupTableView() {
    let cell = UINib(nibName: "IngredientSellectedTableViewCell", bundle: nil)
    tableView.register(cell, forCellReuseIdentifier: "IngredientSellectedTableViewCell")
    
    let totalCell = UINib(nibName: "TotalOderPriceTableViewCell", bundle: nil)
    tableView.register(totalCell, forCellReuseIdentifier: "TotalOderPriceTableViewCell")
    
    let confirmCell = UINib(nibName: "ConfirmOrderTableViewCell", bundle: nil)
    tableView.register(confirmCell, forCellReuseIdentifier: "ConfirmOrderTableViewCell")
  }
  
  func setupObservable() {
    viewModel.createOrderSuccessSignal
      .subscribe(onNext: {[weak self] _ in
        self?.hideLoadingIndicator()
        self?.navigationController?.popToRootViewController(animated: true)
        self?.pushNoticationFinishOrder()
      }, onError: nil, onCompleted: nil, onDisposed: nil)
    .disposed(by: disposeBag)
    
    viewModel.createOrderErrorSignal
      .subscribe(onNext: {[weak self] message in
        self?.hideLoadingIndicator()
        self?.view.makeToast(message)
      }, onError: nil, onCompleted: nil, onDisposed: nil)
    .disposed(by: disposeBag)
    
    viewModel.getListPaymentSignal
      .subscribe(onNext: {[weak self] _ in
        guard let self = self else { return }
        self.tableView.reloadData()
      }, onError: nil, onCompleted: nil, onDisposed: nil)
    .disposed(by: disposeBag)
  }
  
  func pushNoticationFinishOrder() {
    NotificationCenter.default.post(name: Notification.Name("finishOrder"), object: self, userInfo: nil)
  }
}

extension ConfirmOrderViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let total = viewModel.totalIngredients.count
    if indexPath.row == 3 + total {
      return 225
    } else {
      return UITableView.automaticDimension
    }
  }
}

extension ConfirmOrderViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.totalIngredients.count + 4
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let total = viewModel.totalIngredients.count
    switch indexPath.row {
    case 0:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientSellectedTableViewCell", for: indexPath) as? IngredientSellectedTableViewCell else { return UITableViewCell() }
      cell.loadData(title: "Smoothie:", isBold: true)
      return cell
      
    case 1:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientSellectedTableViewCell", for: indexPath) as? IngredientSellectedTableViewCell else { return UITableViewCell() }
      let text = viewModel.order.name + "x" + String(viewModel.order.serving) + "servings"
      cell.loadData(title: text, isBold: false)
      return cell
      
    case 2:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientSellectedTableViewCell", for: indexPath) as? IngredientSellectedTableViewCell else { return UITableViewCell() }
      cell.loadData(title: "Order items:", isBold: true)
      return cell
      
    case 3 ..< 3 + total:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientSellectedTableViewCell", for: indexPath) as? IngredientSellectedTableViewCell else { return UITableViewCell() }
      let text = viewModel.totalIngredients[indexPath.row - 3].name
      cell.loadData(title: text, isBold: false)
      return cell
      
    case 3 + total:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "TotalOderPriceTableViewCell", for: indexPath) as? TotalOderPriceTableViewCell else { return UITableViewCell() }
      cell.setOrderTitle(title: "Confirm Order")
      cell.totalLabel.text = String(viewModel.order.price) + "USD"
      
      var titlePayment = "Add your payment"
      if let payment = viewModel.cardDefault {
        titlePayment = (payment.allResponseFields["brand"] as? String) ?? "" + " Ending In " + payment.last4
      }
      cell.paymentMethodButton.setTitle(titlePayment, for: UIControl.State.normal)
      cell.paymentMethodButton.addTarget(self, action: #selector(showListPayment), for: .touchUpInside)
      cell.orderButton.addTarget(self, action: #selector(createOrder), for: .touchUpInside)
      
      return cell
      
    default:
      return UITableViewCell()
    }
  }
  
  @objc func createOrder(_ sender: Any) {
    if viewModel.cardDefault == nil {
      return
    }
    showLoadingIndicator()
    viewModel.charge()
  }
  
  @objc func showListPayment(_ sender: Any) {
    let stripeVM = StripePaymentMethodViewModel(viewModel.listCards, card: viewModel.cardDefault)
    let vc = StripePaymentMethodsViewController.instantiate(viewModel: stripeVM)
    navigationController?.pushViewController(vc, animated: true)
    
    stripeVM.updateCardDefaultSignal
      .subscribe(onNext: {[weak self] card in
        guard let self = self else { return }
        self.viewModel.cardDefault = card
        let index = 3 + self.viewModel.totalIngredients.count
        self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
      }, onError: nil, onCompleted: nil, onDisposed: nil)
    .disposed(by: disposeBag)
  }
}
