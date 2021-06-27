//
//  StateModel.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 4/27/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//


// Define the variables for the shipping system (state/city)
// Define the cities and the states options for deluvery option (Delivery Form)
// Define and set thee cities and states option for the delivery form on the App IOS

import Foundation

class StateModel: Codable {
  var stateID: String = ""
  var statename: String = ""
  var cities: [String] = []
  
  enum CodingKeys: String, CodingKey {
    case stateID = "state_id"
    case statename
    case cities
  }
}
