//
//  StripePaymentMethodsViewController.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 4/22/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit
//import Stripe
//import RxSwift
//import Toast_Swift

class StripePaymentMethodsViewController: BaseViewController {
  
  @IBOutlet weak var cardImageView: UIImageView!
  @IBOutlet weak var tableView: UITableView!
  var viewModel: StripePaymentMethodViewModelType!
  
  internal static func instantiate(viewModel: StripePaymentMethodViewModel) -> StripePaymentMethodsViewController {
    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StripePaymentMethodsViewController") as! StripePaymentMethodsViewController
    vc.viewModel = viewModel
    return vc
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupVC()
    setupTableView()
    setupObservable()
  }
  
  @IBAction func backVC(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func addNewMethod(_ sender: Any) {
    showLoadingIndicator()
    viewModel.setCardDefault()
  }
}

extension StripePaymentMethodsViewController {
  
  func setupVC() {
    view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    title = "Payment Method"
    cardImageView.image = UIImage(named: "stp_card_form_front")
    cardImageView.setTintColor(UIColor(red: 0/255, green: 179/255, blue: 251/255, alpha: 1))
  }
  
  func setupTableView() {
    tableView.backgroundColor = UIColor.clear
    tableView.delegate = self
    tableView.dataSource = self
    
    let cell = UINib(nibName: "PaymentTableViewCell", bundle: nil)
    tableView.register(cell, forCellReuseIdentifier: "PaymentTableViewCell")
  }
  
  func setupObservable() {
    viewModel.addPaymentSuccessSignal
      .subscribe(onNext: {[weak self] _ in
        self?.dismiss(animated: true, completion: nil)
        self?.tableView.reloadData()
        
      }, onError: nil, onCompleted: nil, onDisposed: nil)
    .disposed(by: disposeBag)
    
    viewModel.addPaymentFailSignal
      .subscribe(onNext: {[weak self] message in
        guard let self = self else { return }
        self.dismiss(animated: true, completion: nil)
        self.view.makeToast(message)
        }, onError: nil, onCompleted: nil, onDisposed: nil)
    .disposed(by: disposeBag)
    
    viewModel.setCardDefaultSuccessSignal
      .subscribe(onNext: {[weak self] _ in
        guard let self = self else { return }
        self.hideLoadingIndicator()
        self.navigationController?.popViewController(animated: true)
        if let card = self.viewModel.cardDefault {
          self.viewModel.updateCardDefaultSignal.onNext(card)
        }
        
      }, onError: nil, onCompleted: nil, onDisposed: nil)
    .disposed(by: disposeBag)
    
    viewModel.setCardDefaultFailSignal
      .subscribe(onNext: {[weak self] message in
        self?.hideLoadingIndicator()
        self?.view.makeToast(message)
      }, onError: nil, onCompleted: nil, onDisposed: nil)
    .disposed(by: disposeBag)
  }
}

extension StripePaymentMethodsViewController: STPAddCardViewControllerDelegate {
  func addNewPayment() {
    let theme = STPTheme()
    theme.accentColor = UIColor(red: 84/255, green: 208/255, blue: 224/255, alpha: 0.5)
    let card = STPAddCardViewController(configuration: STPPaymentConfiguration.shared(), theme: theme)
    card.delegate = self
    let navi = UINavigationController(rootViewController: card)
    present(navi, animated: true, completion: nil)
  }
  
  func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
    dismiss(animated: true, completion: nil)
  }
  
  func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
    viewModel.checkCardAdd(token: token)
  }
}

extension StripePaymentMethodsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return section == 0 ? 25 : 0
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 10))
    footer.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    return footer
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section {
    case 0:
      viewModel.cardDefault = viewModel.listCards[indexPath.row]
      tableView.reloadData()
    default:
      addNewPayment()
    }
  }
}

extension StripePaymentMethodsViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return section == 0 ? viewModel.listCards.count : 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentTableViewCell", for: indexPath) as? PaymentTableViewCell else { return UITableViewCell() }
    let card: STPCard? = indexPath.section == 0 ? viewModel.listCards[indexPath.row] : nil
    cell.loadData(card: card, isShowLine: card != nil && indexPath.row < viewModel.listCards.count - 1, isDefault: card != nil && card == viewModel.cardDefault)
    return cell
  }
}
