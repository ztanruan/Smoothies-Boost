//
//  StripeCustomerContext.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 4/20/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//



// Import stripe library to verify user payment system
// This class will verify user payment cards and store it into the data base

import Stripe

class MockCustomerContext: STPCustomerContext {
  
  var customer = MockCustomer()
  
  override func retrieveCustomer(_ completion: STPCustomerCompletionBlock? = nil) {
    if let completion = completion {
      completion(customer, nil)
    }
  }
  
    // Func to attach the user/delivery information to userID and update database
    
  override func attachSource(toCustomer source: STPSourceProtocol, completion: @escaping STPErrorBlock) {
    if let token = source as? STPToken, let card = token.card {
      customer.sources.append(card)
    }
    completion(nil)
  }
    
    // Func to link the shipping address and delivery order to the user in the database
  
  override func selectDefaultCustomerSource(_ source: STPSourceProtocol, completion: @escaping STPErrorBlock) {
    if customer.sources.contains(where: { $0.stripeID == source.stripeID }) {
      customer.defaultSource = source
    }
    completion(nil)
  }
  
    // Define the func to updatecustomer shipping address and check the fill is not empty
    
  override func updateCustomer(withShippingAddress shipping: STPAddress, completion: STPErrorBlock?) {
    customer.shippingAddress = shipping
    if let completion = completion {
      completion(nil)
    }
  }
  
    
   // Use STPSourceProtocol to verify user cards information
    
  override func detachSource(fromCustomer source: STPSourceProtocol, completion: STPErrorBlock?) {
    if let index = customer.sources.index(where: { $0.stripeID == source.stripeID }) {
      customer.sources.remove(at: index)
    }
    if let completion = completion {
      completion(nil)
    }
  }
}
