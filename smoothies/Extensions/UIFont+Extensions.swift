//
//  UIFont+Extensions.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 3/21/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit

 // Extension for fonts and UI Design
 // Define and initialize the imported/custom fonts in the App

extension UIFont {
  
  class func RalewayMedium(_ size: CGFloat) -> UIFont {
    return UIFont(name: "Raleway-Medium", size: size)!
  }
  
  class func RalewayBold(_ size: CGFloat) -> UIFont {
    return UIFont(name: "Raleway-Bold", size: size)!
  }
  
  class func RalewayLightItalic(_ size: CGFloat) -> UIFont {
    return UIFont(name: "Raleway-LightItalic", size: size)!
  }
  
  class func RalewayLight(_ size: CGFloat) -> UIFont {
    return UIFont(name: "Raleway-Light", size: size)!
  }
  
  class func RalewayRegular(_ size: CGFloat) -> UIFont {
    return UIFont(name: "Raleway-Regular", size: size)!
  }
}
