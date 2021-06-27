//
//  CustomerInfomationViewModel.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 3/22/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import RxSwift
import RxCocoa

protocol CustomerInfomationViewModelType {
  var addressVariable: Variable<String> { get set }
  var aptSuiteVariable: Variable<String> { get set }
  var postalCodeVariable: Variable<String> { get set }
  var phoneVariable: Variable<String> { get set }
  var stateSelect: String { get set }
  var citySelect: String { get set }
  var state: [StateModel] { get set }
  var cities: [String] { get set }
  var order: OrderModel { get }
  func validate() -> String?
  func updateOrder()
  var ingredients: [IngredientModel] { get }
  var garnishes: [IngredientModel] { get }
  var drinkwares: [IngredientModel] { get }
}

class CustomerInfomationViewModel: BaseViewModel, CustomerInfomationViewModelType {
  var stateSelect: String = ""
  var citySelect: String = ""
  var state: [StateModel] = []
  var cities: [String] = []
  var order: OrderModel = OrderModel()
  var addressVariable: Variable<String> = Variable<String>("")
  var aptSuiteVariable: Variable<String> = Variable<String>("")
  var postalCodeVariable: Variable<String> = Variable<String>("")
  var phoneVariable: Variable<String> = Variable<String>("")
  var ingredients: [IngredientModel] = []
  var garnishes: [IngredientModel] = []
  var drinkwares: [IngredientModel] = []
  
  override init() {
    super.init()
  }
  
  init(order: OrderModel, ingredients: [IngredientModel], garnishes: [IngredientModel], drinkwares: [IngredientModel]) {
    super.init()
    self.order = order
    self.getListState()
    self.ingredients = ingredients
    self.garnishes = garnishes
    self.drinkwares = drinkwares
  }
  
  func validate() -> String? {
    if addressVariable.value.isBlank { return "Please input address" }
    if stateSelect.isBlank { return "Please choose state" }
    if citySelect.isBlank { return "Please choose city" }
    if postalCodeVariable.value.isBlank { return "Please input postal code" }
    let phone = phoneVariable.value
    if phone.isBlank || !phone.isPhoneNumberValid(number: 10)  { return "Phone invalid" }
    return nil
  }
  
  func getListState() {
    ProductApi.getListStates()
      .subscribe(onNext: { states in
        self.state = states
      }, onError: { error in
        print("Error")
      }, onCompleted: nil, onDisposed: nil)
      .disposed(by: self.disposebag)
  }
  
  func updateOrder() {
    order.customerInfo.address = addressVariable.value
    order.customerInfo.phone = phoneVariable.value
    order.customerInfo.postalCode = postalCodeVariable.value
    order.customerInfo.apt = aptSuiteVariable.value
    order.customerInfo.city = citySelect
    order.customerInfo.state = stateSelect
    
    order.orderID = "".randomIdString()
  }
}
