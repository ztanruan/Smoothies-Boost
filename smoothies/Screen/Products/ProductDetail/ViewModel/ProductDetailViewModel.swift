//
//  ProductDetailViewModel.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 3/15/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import RxSwift

protocol ProductDetailViewModelType {
  var product: ProductModel { get }
  var ingrendients: [IngredientModel] { get }
  func createOrderModel() -> OrderModel
  var likeSuccessSignal: PublishSubject<Bool> { get }
  var likeFailSignal: PublishSubject<String> { get }
  func likeProduct()
}

class ProductDetailViewModel: BaseViewModel, ProductDetailViewModelType {
  var ingrendients: [IngredientModel] = []
  var product: ProductModel = ProductModel()
  
  var likeSuccessSignal: PublishSubject<Bool> = PublishSubject<Bool>()
  var likeFailSignal: PublishSubject<String> = PublishSubject<String>()
  
  init(product: ProductModel) {
    self.product = product
    
    super.init()

    self.setupIngrendients()
  }
  
  func setupIngrendients() {
    self.ingrendients = self.product.ingredients
    
    let served: IngredientModel = IngredientModel()
    served.initMockData(name: self.product.served, price: 0, unit: "", type: .serve)
    self.ingrendients.append(served)
    
    let standarNames = self.product.standardGarnish.compactMap { $0.name }
    let standardName = standarNames.joined(separator: ", ")
    let standard: IngredientModel = IngredientModel()
    standard.initMockData(name: standardName, price: 0, unit: "", type: .standard)
    self.ingrendients.append(standard)
    
    let drinkwareNames = self.product.drinkware.compactMap { $0.name }
    let drinkName = drinkwareNames.joined(separator: ", ")
    let drinkware: IngredientModel = IngredientModel()
    drinkware.initMockData(name: drinkName, price: 0, unit: "", type: .drinkware)
    self.ingrendients.append(drinkware)
  }
  
  func createOrderModel() -> OrderModel {
    let orderModel = OrderModel()
    orderModel.name = product.name
    orderModel.productID = product.id
    orderModel.status = OrderStatus.Processed.rawValue
    orderModel.image = product.image
    return orderModel
  }
  
  func likeProduct() {
    ProductApi.likeProduct(product: self.product)
      .subscribe(onNext: {[weak self] isLike in
        self?.likeSuccessSignal.onNext(isLike)
      }, onError: {[weak self] error in
        self?.likeFailSignal.onNext((error as! ErrorMessage).message)
      }, onCompleted: nil, onDisposed: nil)
    .disposed(by: disposebag)
  }
}
