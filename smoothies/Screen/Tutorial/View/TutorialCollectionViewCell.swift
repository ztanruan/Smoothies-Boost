//
//  TutorialCollectionViewCell.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 4/21/19.
//  Copyright © 2019 zhen xin tan ruan. All rights reserved.
//

import UIKit

class TutorialCollectionViewCell: UICollectionViewCell, ReusableView, NibloadableView {

  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var itemImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

  func loadCell(item: TutorialModel) {
    titleLabel.text = item.title
    descriptionLabel.text = item.descriptionInfor
    itemImageView.image = item.image
    itemImageView.contentMode = .scaleAspectFit
  }
}

