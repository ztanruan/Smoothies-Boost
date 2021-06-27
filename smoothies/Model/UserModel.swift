//
//  UserModel.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 4/27/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//


// Initialize the variables that we are going to use in the database
// Role: 0 for user/clients , 1 for Manager
// Use the userID and email to verify user account information

import Foundation

class UserModel: Codable {
  static var currentUser = UserModel()
  
  var phone: String = ""
  var userID: String = ""
  var username: String = ""
  var email: String = ""
  var point: Int = 0
  var role: Int = 0
  var token: String = ""
  var avatar: String = ""
  var fcmtoken: String = ""
  
  
  // Define and initialize the casee statement for each product
    
  enum CodingKeys: String, CodingKey {
    case userID = "user_id"
    case username
    case email
    case point
    case phone
    case role
    case avatar
    case token
    case fcmtoken
  }
  
    // Define the variable for user authentication system
    // UserID, email and random token
    
  func initFromAuth(userID: String, email: String, token: String) {
    self.userID = userID
    self.email = email
    self.token = token
  }
}
