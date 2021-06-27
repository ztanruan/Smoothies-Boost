//
//  OrderCollectionViewCell.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 4/8/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit
import Kingfisher

class OrderCollectionViewCell: UICollectionViewCell, ReusableView, NibloadableView {
  
  @IBOutlet weak var orderImageView: UIImageView!
  @IBOutlet weak var ordernameLabel: UILabel!
  @IBOutlet weak var orderIdLabel: UILabel!
  @IBOutlet weak var numberServiceLabel: UILabel!
  @IBOutlet weak var estimateTimeLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var statusOrderLabel: UILabel!

  @IBOutlet weak var lineView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    setupView()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    lineView.drawDottedLine(start: CGPoint(x: self.lineView.bounds.origin.x, y: self.lineView.bounds.origin.y),
                            end: CGPoint(x: self.lineView.bounds.size.width, y: self.lineView.bounds.origin.y))
  }
  
  private func setupView() {
    contentView.masksToBounds = false
    self.masksToBounds = false
    self.clipsToBounds = false
    self.setShadowWithColor(UIColor.lightGray, 0.7, CGSize(width: 1.5, height: 1.5), 5, 5)
  }
  
  func loadData(order: OrderModel) {
    orderImageView.loadImage(fromUrl: URL(string: order.image))
    ordernameLabel.text = order.name
    orderIdLabel.text = String(order.orderID.prefix(10))
    numberServiceLabel.text = String(order.serving)
    estimateTimeLabel.text = order.arrived
    priceLabel.text = String(order.price) + "USD"
    statusOrderLabel.text = order.status
  }
}
