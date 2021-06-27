//
//  ProductCollectionViewCell.swift
//  smoothie
//
//  Created by zhen xin  tan ruan on 3/14/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit
import Cosmos
class ProductCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var itemImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var cateLabel: UILabel!
  @IBOutlet weak var ratingView: CosmosView!
  @IBOutlet weak var detailButton: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func loadCell(product: ProductModel) {
    itemImageView.loadImage(fromUrl: URL(string: product.image))
    nameLabel.text = product.name
    cateLabel.text = product.cate
    ratingView.rating = product.rating ?? 0.0
  }
}
