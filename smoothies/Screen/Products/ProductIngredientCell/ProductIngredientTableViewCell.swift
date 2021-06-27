//
//  ProductIngredientTableViewCell.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 3/12/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit

class ProductIngredientTableViewCell: UITableViewCell {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var ingredientLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func loadCell(ingredient: IngredientModel) {
    titleLabel.font = UIFont.RalewayBold(14)
    switch ingredient.type {
    case .normal:
      titleLabel.font = UIFont.RalewayMedium(14)
      titleLabel.text = ingredient.name
      ingredientLabel.text = nil
    case .drinkware:
      titleLabel.text = "Drinkware:"
      ingredientLabel.text = ingredient.name
    case .serve:
      titleLabel.text = "Served:"
      ingredientLabel.text = ingredient.name
    case .standard:
      titleLabel.text = "Standard garnish:"
      ingredientLabel.text = ingredient.name
    }
  }
}
