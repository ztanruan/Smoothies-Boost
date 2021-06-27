//
//  CornerRadiusView.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 4/5/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit

class CornerRadiusView: UIView {
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    self.clipsToBounds = true
    self.layer.cornerRadius = rect.size.height / 2
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.layer.cornerRadius = frame.size.height / 2
  }
}
