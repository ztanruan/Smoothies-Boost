//
//  ListOrderViewModel.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 4/2/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import RxSwift

protocol ListOrderViewModelType {
  var orders: [OrderModel] { get set }
  
  var getlistSuccessSignal: PublishSubject<Void> { get }
  var getlistFailSignal: PublishSubject<String> { get }
}

class ListOrderViewModel: BaseViewModel, ListOrderViewModelType {
  var orders: [OrderModel] = []
  var getlistSuccessSignal: PublishSubject = PublishSubject<Void>()
  var getlistFailSignal: PublishSubject = PublishSubject<String>()
  
  override init() {
    super.init()

    self.getlistOrders()
  }
  
  func getlistOrders() {
    OrderApi.getListOrdersByUser()
      .subscribe(onNext: {[weak self] orders in
        self?.orders = orders
        self?.getlistSuccessSignal.onNext(Void())
        
      }, onError: {[weak self] error in
        self?.getlistFailSignal.onNext((error as! ErrorMessage).message)
        
      }, onCompleted: nil, onDisposed: nil)
    .disposed(by: disposebag)
  }
}
