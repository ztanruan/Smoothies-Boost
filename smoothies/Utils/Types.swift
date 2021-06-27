//
//  Types.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 3/19/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//


// Import UIKit library

import UIKit

// Define and initialize case statement for Func

enum ItemSlideMenuType {
  case smoothies
  case account
  case myorder
  case location
  case about
  case manage
  case signout
  
    // Display View Controller
    // Define User view controller User interface
    
  func getVC() -> UIViewController {
    switch self {
    case .smoothies:
      let vc = UIStoryboard.init(name: "Main",
                                 bundle: nil)
        .instantiateViewController(withIdentifier: "ListProductViewController")
      return vc
      
    case .account:
      let vc = UIStoryboard.init(name: "Main",
                                 bundle: nil)
        .instantiateViewController(withIdentifier: "ProfileViewController")
      return vc
      
    case .myorder:
      let vc = UIStoryboard.init(name: "Main",
                                 bundle: nil)
        .instantiateViewController(withIdentifier: "ListOrderViewController")
      return vc
        
    case .location:
        let vc = UIStoryboard.init(name: "Main",
                                   bundle: nil)
            .instantiateViewController(withIdentifier: "MapViewController")
        return vc
        
    case .about:
        let vc = UIStoryboard.init(name: "Main",
                                   bundle: nil)
            .instantiateViewController(withIdentifier: "AboutUs")
        return vc
      
    case .manage:
      let vc = UIStoryboard.init(name: "Main",
                                 bundle: nil)
        .instantiateViewController(withIdentifier: "ManageViewController")
      return vc
    case .signout:
      return UIViewController()
    }
  }
}


    // Define and Initialize the variables and object for Ingredient Fuc

enum IngredientType {
  case normal
  case serve
  case standard
  case drinkware
}

enum RegularExpressions: String {
  case phone = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"
  case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
}

    // Define the two inteerface in the app
    // Manager and User Interface Case

enum RoleApp: Int {
  case superAdmin = 1
  case user = 0
}
