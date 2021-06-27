//
//  IngredientHeaderTableViewCell.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 3/18/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit

class IngredientHeaderTableViewCell: UITableViewCell {
  @IBOutlet weak var titleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func loadData(_ title: String) {
    titleLabel.text = title
  }
}
