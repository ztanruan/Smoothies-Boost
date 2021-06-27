//
//  UpdateStatusOrderViewModel.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 4/21/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit
import RxSwift

protocol UpdateStatusOrderViewModelType {
  var order: OrderModel! { get }
  var updateSuccessSignal: PublishSubject<Void> { get }
  var updateFailSignal: PublishSubject<String> { get }
  func updateStatus(status: String)

}

class UpdateStatusOrderViewModel: BaseViewModel, UpdateStatusOrderViewModelType {
  var order: OrderModel!
  
  var updateSuccessSignal: PublishSubject = PublishSubject<Void>()
  var updateFailSignal: PublishSubject = PublishSubject<String>()
  
  init(order: OrderModel) {
    self.order = order
  }
  
  func updateStatus(status: String) {
    let orderID = order.orderID
    OrderApi.updateStatusOrder(orderid: orderID, status: status)
      .subscribe(onNext: {[weak self] updatedOrder in
        self?.order = updatedOrder
        self?.updateSuccessSignal.onNext(Void())
        
      }, onError: {[weak self] error in
        self?.updateFailSignal.onNext((error as! ErrorMessage).message)
        
      }, onCompleted: nil, onDisposed: nil)
    .disposed(by: disposebag)
  }
}
