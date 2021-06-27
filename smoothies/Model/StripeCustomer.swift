//
//  StripeCustomer.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 4/27/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//



// Import stripe API and library to verify user payment system
// Stripe will authenticate and verify user paymnet information
// Template taken from SKD Library of stripe


// Define and initialize variables and object required to use stripe function to verify user method payment
// Import Stripe library and SKD


import Stripe

class MockCustomer: STPCustomer {
  var mockSources: [STPSourceProtocol] = []
  var mockDefaultSource: STPSourceProtocol? = nil
  var mockShippingAddress: STPAddress?
  
  override init() {
    
  }
  
    // Define the func that we will need to implement and use stripe library in the App
    // Define and initialize the default values for each field and variable
    
  override var sources: [STPSourceProtocol] {
    get {
      return mockSources
    }
    set {
      mockSources = newValue
    }
  }
  
  override var defaultSource: STPSourceProtocol? {
    get {
      return mockDefaultSource
    }
    set {
      mockDefaultSource = newValue
    }
  }
    
    
   // Define the variable shippingAddress and store the information in the user database
  
  override var shippingAddress: STPAddress? {
    get {
      return mockShippingAddress
    }
    set {
      mockShippingAddress = newValue
    }
  }
}
