//
//  SegmentButton.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 4/5/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit

class SegmentButton: UIView {
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var button: UIButton!
  @IBOutlet weak var segmentView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    Bundle.main.loadNibNamed("SegmentButton", owner: self, options: nil)
    self.addSubview(contentView)
    contentView.translatesAutoresizingMaskIntoConstraints = false
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": contentView]))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": contentView]))
  }
  
  func setTitleButton(_ title: String) {
    button.setTitle(title, for: .normal)
  }
  
  func setSelectedState() {
    let titleButtonColor =
      UIColor(red: 24/255, green: 24/255, blue: 24/255, alpha: 1)
    button.setTitleColor(titleButtonColor, for: .normal)
    segmentView.backgroundColor = UIColor(red: 84/255, green: 208/255, blue: 224/255, alpha: 1)
  }
  
  func setUnSelectedState() {
    let titleButtonColor = UIColor(red: 157/255, green: 174/255, blue: 182/255, alpha: 1)
    button.setTitleColor(titleButtonColor, for: .normal)
    segmentView.backgroundColor = UIColor.clear
  }
}
