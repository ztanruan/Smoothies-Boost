//
//  Constants.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 3/16/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//


 // Import UIKit for graphical controller
 // Initialize the paramters
 // Customize the view controller

import UIKit

struct Constants {
  struct ScreenSize {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
  }
  
  struct SlideMenu {
    static let ratio: CGFloat = 280 / 375
  }
  
  struct FirebaseConstant {
    static var token: String = ""
    static let phonePrefix = "+1"
  }
}
