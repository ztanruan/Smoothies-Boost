//
//  IngredientSellectedTableViewCell.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 4/23/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit

class IngredientSellectedTableViewCell: UITableViewCell {
  @IBOutlet weak var titleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func loadData(title: String, isBold: Bool) {
    titleLabel.font = isBold ? UIFont.RalewayBold(15.0) : UIFont.RalewayRegular(15.0)
    titleLabel.text = title
  }
}
