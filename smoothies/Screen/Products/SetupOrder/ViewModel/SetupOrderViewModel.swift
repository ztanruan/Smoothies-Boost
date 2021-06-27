//
//  SetupOrderViewModel.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 3/18/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit

protocol SetupOrderViewModelType {
  var order: OrderModel { get }
  var ingredients: [IngredientModel] { get }
  var garnishs: [IngredientModel] { get }
  var drinkWares: [IngredientModel] { get }
  var served: [Int] { get }
  var servingValue: Int { get set }
  func totalPrice() -> Int
}

class SetupOrderViewModel: SetupOrderViewModelType {
  var order: OrderModel = OrderModel()
  var servingValue: Int = 10
  var ingredients: [IngredientModel] = []
  var garnishs: [IngredientModel] = []
  var drinkWares: [IngredientModel] = []
  var served: [Int] = []
  
  init(ingredients: [IngredientModel],
       garnishs: [IngredientModel],
       drinkWares: [IngredientModel],
       served: [Int],
       order: OrderModel) {
    self.ingredients = ingredients
    self.garnishs = garnishs
    self.drinkWares = drinkWares
    self.served = served
    self.order = order
    if !served.isEmpty {
      self.servingValue = served[0]
    }
  }
  
  func totalPrice() -> Int {
    let ingredientSelects = ingredients.filter({ $0.isSelect })
    let drinkWareSelects = drinkWares.filter({ $0.isSelect })
    let granishSelects = garnishs.filter({ $0.isSelect })
    
    let totalIngredient = ingredientSelects.compactMap { $0.price }.reduce(0, { $0 + $1 })
    let totalDrinkWare = drinkWareSelects.compactMap { $0.price }.reduce(0, { $0 + $1 })
    let totalGranish = granishSelects.compactMap { $0.price }.reduce(0, { $0 + $1 })
    
    let total = servingValue * (totalIngredient + totalDrinkWare + totalGranish)
    return total
  }
}
