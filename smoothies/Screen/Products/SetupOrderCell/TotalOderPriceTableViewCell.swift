//
//  TotalOderPriceTableViewCell.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 3/18/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit

class TotalOderPriceTableViewCell: UITableViewCell {
  
  @IBOutlet weak var totalLabel: UILabel!
  @IBOutlet weak var paymentViewHeight: NSLayoutConstraint!
  @IBOutlet weak var orderButton: UIButton!
  @IBOutlet weak var paymentMethodButton: UIButton!

  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func hidePaymentButton() {
    paymentViewHeight.constant = 0
    paymentMethodButton.isHidden = true
  }
  
  func setOrderTitle(title: String) {
    orderButton.setTitle(title, for: .normal)
  }
}
