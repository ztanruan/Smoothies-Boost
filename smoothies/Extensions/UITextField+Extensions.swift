//
//  UITextField+Extensions.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 3/24/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit


 // Class extension to deefine place holder color (Default)

extension UITextField {
  
  func setColorForPlaceholder(color: UIColor) {
    self.attributedPlaceholder =
      NSAttributedString(string: self.placeholder ?? "",
                         attributes: [NSAttributedString.Key.foregroundColor: color])
  }
}
