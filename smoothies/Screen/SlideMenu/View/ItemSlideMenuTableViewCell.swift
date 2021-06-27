//
//  ItemSlideMenuTableViewCell.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 4/26/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit

class ItemSlideMenuTableViewCell: UITableViewCell, ReusableView, NibloadableView {

  @IBOutlet weak var iconImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
  
  func loadData(item: ItemSlideMenu) {
    iconImageView.image = item.icon
    titleLabel.text = item.name
  }
}
