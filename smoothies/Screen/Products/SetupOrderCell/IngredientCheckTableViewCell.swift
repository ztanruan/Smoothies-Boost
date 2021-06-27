//
//  IngredientCheckTableViewCell.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 3/18/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit

class IngredientCheckTableViewCell: UITableViewCell {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var checkButton: UIButton!
  
  var callBack: ((_ index: Int) -> Void)?
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  @IBAction func checkbox(_ sender: UIButton) {
    sender.isSelected = !sender.isSelected
    callBack?(sender.tag)
  }
  
  func loadData(data: IngredientModel, index: Int) {
    checkButton.isSelected = data.isSelect
    checkButton.tag = index
    titleLabel.text = data.name
  }
}
