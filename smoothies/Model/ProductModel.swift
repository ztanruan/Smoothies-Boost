//
//  ProductModel.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 4/27/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//


// This swift file contains the functions that we need for product view controller
// Import UIKit to construct and manage a graphical

import UIKit



// Define and initialize variables that we are going to use in the product view controller
// This class define the information that we are going to use to display the order information

class ProductModel: Codable {
  var id: String = ""
  var image: String = ""
  var name: String = ""
  var cate: String = ""
  var time: Int = 0
  var ingredients: [IngredientModel] = []
  var served: String = ""
  var standardGarnish: [IngredientModel] = []
  var drinkware: [IngredientModel] = []
  var preparation: String = ""
  var servings: [Int] = []
  var userLikes: [String]? = []
  var rating: Double? {
    let totalLike = userLikes?.count ?? 0
    return totalLike >= 10 ? 5.0 : (totalLike >= 8 ? 4.0 : (totalLike == 7 ? 3.0 : (totalLike == 6 ? 2.0 : (totalLike == 5 ? 1.0 : 0.0))))
  }
    
// Define the case for details of the products
  
  enum CodingKeys: String, CodingKey {
    case id = "product_id"
    case image
    case name
    case cate
    case time
    case ingredients
    case served
    case standardGarnish
    case drinkware
    case preparation
    case servings
    case userLikes
  }
  
    
 // This function display the ingredients and product details
    
  func initMockData(id: String = "121902190129",
                    image: String = "https://www.discountmugs.com/product-images/gallery-zoom/225249-SB271_GROUP_FINAL_1K.jpg",
                    name: String = "Bottle",
                    cate: String = "smoothie",
                    time: Int = 3,
                    ingredients: [IngredientModel] = [],
                    served: String = "Yes",
                    standardGarnish: [IngredientModel] = [],
                    drinkware: [IngredientModel] = [],
                    preparation: String = "Done",
                    servings: [Int] = [1, 2],
                    userLikes: [String] = []) {
    
    
    // Define the variables and assign the object to each variable
    
    self.id = id
    self.image = image
    self.name = name
    self.cate = cate
    self.time = time
    self.ingredients = ingredients
    self.served = served
    self.standardGarnish = standardGarnish
    self.drinkware = drinkware
    self.preparation = preparation
    self.servings = servings
    self.userLikes = userLikes
  }
}


    // Define the variables for the details of the products
    // Name, price, unit, and type

class IngredientModel: Codable {
  var name: String = ""
  var price: Int = 0
  var unit: String = ""
  var type: IngredientType = .normal
  var isSelect = true

  enum CodingKeys: String, CodingKey {
    case name
    case price
    case unit
  }
    
    
    // Initialize the variables for the products in the app
    // Define the default price and unit
  
  func initMockData(name: String = "Sugar",
                    price: Int = 150,
                    unit: String = "USD",
                    type: IngredientType = .normal) {
    self.name = name
    self.price = price
    self.unit = unit
    self.type = type
    self.isSelect = true
  }
}

