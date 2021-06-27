//
//  DropdownTableViewCell.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 3/26/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit

class SelectionTableViewCell: UITableViewCell {
  @IBOutlet weak var iconImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  var callBack: (() -> Void)?
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  @IBAction func handleChoose(_ sender: Any) {
    callBack?()
  }
  
  func loadData(icon: UIImage?, title: String) {
    iconImageView.image = icon
    titleLabel.text = title
  }
}
