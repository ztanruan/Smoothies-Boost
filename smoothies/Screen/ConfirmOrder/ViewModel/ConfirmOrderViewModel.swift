//
//  ConfirmOrderViewModel.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 4/23/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import RxSwift
import Stripe

protocol ConfirmOrderViewModelType {
  var order: OrderModel { get }
  var ingredients: [IngredientModel] { get }
  var garnishs: [IngredientModel] { get }
  var drinkWares: [IngredientModel] { get }
  var totalIngredients: [IngredientModel] { get }
  var listCards: [STPCard] { get }
  var cardDefault: STPCard? { get set }
  
  var createOrderSuccessSignal: PublishSubject<Void> { get }
  var createOrderErrorSignal: PublishSubject<String> { get }
  var getListPaymentSignal: PublishSubject<Void> { get }

  func getListPaymentSources()
  func charge()
}

class ConfirmOrderViewModel: BaseViewModel, ConfirmOrderViewModelType {
  var order: OrderModel = OrderModel()
  var ingredients: [IngredientModel] = []
  var garnishs: [IngredientModel] = []
  var drinkWares: [IngredientModel] = []
  var totalIngredients: [IngredientModel] {
    return ingredients + garnishs + drinkWares
  }
  var listCards: [STPCard] = []
  var cardDefault: STPCard?

  var createOrderSuccessSignal: PublishSubject = PublishSubject<Void>()
  var createOrderErrorSignal: PublishSubject = PublishSubject<String>()
  var getListPaymentSignal: PublishSubject = PublishSubject<Void>()

  init(ingredients: [IngredientModel],
       garnishs: [IngredientModel],
       drinkWares: [IngredientModel],
       order: OrderModel) {
    self.ingredients = ingredients
    self.garnishs = garnishs
    self.drinkWares = drinkWares
    self.order = order
  }
  
  func createOrder() {
    OrderApi.createOrder(order: order)
      .subscribe(onNext: {[weak self] newOrder in
        self?.createOrderSuccessSignal.onNext(Void())
        self?.updatePoint()
      }, onError: { [weak self] error in
        self?.createOrderErrorSignal.onNext((error as! ErrorMessage).message)
      }, onCompleted: nil, onDisposed: nil)
    .disposed(by: disposebag)
  }
  
  func updatePoint() {
    AuthenApi.updatePoint()
      .subscribe(onNext: { _ in
        
      }, onError: nil, onCompleted: nil, onDisposed: nil)
    .disposed(by: disposebag)
  }
  
  func getListPaymentSources() {
    StripeApi.getListPaymentSource()
      .subscribe(onNext: {[weak self] cards in
        self?.listCards = cards
        self?.getPaymentDefault()
      }, onError: { error in
        print("Error")
      }, onCompleted: nil, onDisposed: nil)
      .disposed(by: disposebag)
  }
  
  func getPaymentDefault() {
    StripeApi.getPaymentDefaultId()
      .subscribe(onNext: {[weak self] id in
        self?.cardDefault = self?.setPaymentDefault(id: id)
        self?.getListPaymentSignal.onNext(Void())
      }, onError: nil, onCompleted: nil, onDisposed: nil)
    .disposed(by: disposebag)
  }
  
  func charge() {
    guard let timeDeliver = "".getTimeDeliver() else {
      createOrderErrorSignal.onNext("We are currently close, we will open at 9 am")
      return
    }
    order.arrived = timeDeliver
    
    guard let card = cardDefault else { return }
    StripeApi.charge(card: card, amount: order.price*100)
      .subscribe(onNext: {[weak self] isFinish in
        self?.createOrder()
        
      }, onError: {[weak self] error in
        self?.createOrderErrorSignal.onNext((error as! ErrorMessage).message)
        
      }, onCompleted: nil, onDisposed: nil)
    .disposed(by: disposebag)
  }
  
  func setPaymentDefault(id: String) -> STPCard? {
    return listCards.first(where: {($0.allResponseFields["id"] as! String) == id}) ?? listCards.first
  }
}
