//
//  Error.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 3/23/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//


// Template from online from Firebase Library
// Stripe Library template

class ErrorMessage: Error {
  let message: String
  
  init(message: String) {
    self.message = message
  }
}
