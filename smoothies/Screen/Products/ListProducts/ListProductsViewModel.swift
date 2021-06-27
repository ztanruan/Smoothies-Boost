//
//  ListProductsViewModel.swift
//  smoothie
//
//  Created by zhen xin  tan ruan on 3/14/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import RxSwift

protocol ListProductsViewModelType {
  var products: [ProductModel] { get set }
  func updateProduct(_ product: ProductModel)
}

class ListProductsViewModel: ListProductsViewModelType {
  var products: [ProductModel] = []
  var disposeBag = DisposeBag()
  
  var getListSuccessSignal: PublishSubject = PublishSubject<Void>()
  var getListErrorSignal: PublishSubject = PublishSubject<String>()
  
  init() {
    ProductApi.getListProducts()
      .subscribe(onNext: {[weak self] products in
        self?.products = products
        self?.getListSuccessSignal.onNext(Void())
        }, onError: {[weak self] _ in
          self?.getListErrorSignal.onNext("Can't get list products")
        }, onCompleted: nil, onDisposed: nil)
      .disposed(by: disposeBag)
  }
  
  func updateProduct(_ product: ProductModel) {
    guard let index = products.firstIndex(where: { $0.id == product.id }) else { return }
    products[index] = product
    getListSuccessSignal.onNext(Void())
  }
}
