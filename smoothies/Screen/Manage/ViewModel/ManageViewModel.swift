//
//  ManageViewModel.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 4/23/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import RxSwift

protocol ManageViewModelType {
  var orders: [OrderModel] { get set }
  
  var getlistSuccessSignal: PublishSubject<Void> { get }
  var getlistFailSignal: PublishSubject<String> { get }
  func getlistOrders(status: String)
  func updateOrder(updateOrder: OrderModel)
}

class ManageViewModel: BaseViewModel, ManageViewModelType {
  var orders: [OrderModel] = []
  var getlistSuccessSignal: PublishSubject = PublishSubject<Void>()
  var getlistFailSignal: PublishSubject = PublishSubject<String>()
  
  override init() {
    super.init()
    
    self.getlistOrders(status: "All")
  }
  
  func getlistOrders(status: String) {
    OrderApi.getListOrderByStatus(status: status)
      .subscribe(onNext: {[weak self] orders in
        self?.orders = orders
        self?.getlistSuccessSignal.onNext(Void())
        
        }, onError: {[weak self] error in
          self?.getlistFailSignal.onNext((error as! ErrorMessage).message)
          
        }, onCompleted: nil, onDisposed: nil)
      .disposed(by: disposebag)
  }
  
  func updateOrder(updateOrder: OrderModel) {
    if let index = orders.lastIndex(where: {$0.orderID == updateOrder.orderID}) {
      orders[index] = updateOrder
      getlistSuccessSignal.onNext(Void())
    }
  }
}
