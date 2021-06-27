//
//  OrderModel.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 4/27/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//



// Extend class for the order view controller
// Define the case/option for user order status SHIPPED, DELIVERED, CANCELED AND PROCESSED

import Foundation

enum OrderStatus: String {
  case Processed = "Processed"
  case Shipped = "Shipped"
  case Delivered = "Delivered"
  case Canceled = "Canceled"
}

class OrderModel: Codable {
  var orderID: String = ""
  var productID: String = ""
  var image: String = ""
  var name: String = ""
  var arrived: String = ""
  var serving: Int = 10
  var price: Int = 0
  var unit: String = ""
  var status: String = ""
  var customerInfo: CustomerInfoModel = CustomerInfoModel()
  var userID: String = ""

    
 // Define the variables and object tha are required for the order class
    
  enum CodingKeys: String, CodingKey {
    case orderID = "order_id"
    case productID = "product_id"
    case image
    case name
    case arrived
    case serving
    case price
    case unit
    case status
    case customerInfo
    case userID = "user_id"
  }
  
    
   // Define function to store order information about their order
   // ProductID, Image, Arrived, Serving, Status and Customer Information
    
  func initCustomer(orderID: String, productID: String, image: String, name: String, arrived: String, serving: Int, price: Int, unit: String, status: String, customerInfo: CustomerInfoModel, userID: String) {
    self.orderID = orderID
    self.productID = productID
    self.image = image
    self.arrived = arrived
    self.serving = serving
    self.price = price
    self.unit = unit
    self.status = status
    self.customerInfo = customerInfo
    self.userID = userID
  }
}

class CustomerInfoModel: Codable {
  var address: String = ""
  var apt: String? = ""
  var state: String = ""
  var city: String = ""
  var postalCode: String = ""
  var phone: String = "" // 10 so
    
    // Define and initiazlize the case statement for the shipping form
  
  enum CodingsKeys: String, CodingKey {
    case address
    case apt
    case state
    case city
    case postalCode
    case phone
  }
  
    // Define func to initialze the variables and object in the class
    // Initialize the variables for the shipping form
    
  func initCustomer(address: String, apt: String, state: String, city: String, postalCode: String, phone: String) {
    self.address = address
    self.apt = apt
    self.state = state
    self.city = city
    self.postalCode = postalCode
    self.phone = phone
  }
}
