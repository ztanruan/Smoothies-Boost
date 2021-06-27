//
//  UpdateStatusOrderViewController.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 4/21/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit
import Kingfisher
import DropDown
import RxSwift

class UpdateStatusOrderViewController: BaseViewController {
  
  @IBOutlet private weak var iconImageView: UIImageView!
  @IBOutlet private weak var orderIdLabel: UILabel!
  @IBOutlet private weak var servingLabel: UILabel!
  @IBOutlet private weak var timeLabel: UILabel!
  @IBOutlet private weak var statusLabel: UILabel!
  @IBOutlet private weak var address: UILabel!

  private var viewModel: UpdateStatusOrderViewModelType!
  var updateOrderSignal: PublishSubject = PublishSubject<OrderModel>()
  
  let dataSource = [OrderStatus.Processed.rawValue, OrderStatus.Delivered.rawValue, OrderStatus.Shipped.rawValue]
  let statusDropDown = DropDown()

  internal static func instantiate(viewModel: UpdateStatusOrderViewModel) -> UpdateStatusOrderViewController {
    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UpdateStatusOrderViewController") as! UpdateStatusOrderViewController
    vc.viewModel = viewModel
    return vc
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = viewModel.order.name
    loadData()
    setupObservable()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    layoutView()
  }
  
  @IBAction func handleBack(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func confirmChangeStatus(_ sender: Any) {
    showLoadingIndicator()
    viewModel.updateStatus(status: statusLabel.text ?? "")
  }
  
  @IBAction func showListStatus(_ sender: UIButton) {
    statusDropDown.anchorView = sender.titleLabel
    statusDropDown.dataSource = dataSource
    statusDropDown.show()
    statusDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
      self.statusLabel.text = item
    }
  }
}

extension UpdateStatusOrderViewController {
  
  private func layoutView() {
  }
  
  private func loadData() {
    iconImageView.loadImage(fromUrl: URL(string: viewModel.order.image))
    orderIdLabel.text = String(viewModel.order.orderID.prefix(10))
    servingLabel.text =  "Serving: " + String(viewModel.order.serving)
    timeLabel.text = viewModel.order.arrived
    statusLabel.text = viewModel.order.status
    address.text = "Information: " + viewModel.order.customerInfo.phone + " - " + viewModel.order.customerInfo.address
  }
  
  private func setupObservable() {
    
    viewModel.updateSuccessSignal
      .subscribe(onNext: {[weak self] _ in
        self?.hideLoadingIndicator()
        if let order = self?.viewModel.order {
          self?.updateOrderSignal.onNext(order)
        }
        self?.navigationController?.popViewController(animated: true)
        
        }, onError: nil, onCompleted: nil, onDisposed: nil)
    .disposed(by: disposeBag)
    
    viewModel.updateFailSignal
      .subscribe(onNext: {[weak self] message in
        self?.hideLoadingIndicator()
        self?.view.makeToast(message)
      }, onError: nil, onCompleted: nil, onDisposed: nil)
    .disposed(by: disposeBag)
  }
}
