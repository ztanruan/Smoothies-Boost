//
//  ManageOrderTableViewCell.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 4/23/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit
import Kingfisher

class ManageOrderTableViewCell: UITableViewCell, ReusableView, NibloadableView {

  @IBOutlet weak var statusView: UIImageView!
  @IBOutlet weak var orderImageView: UIImageView!
  @IBOutlet weak var ordernameLabel: UILabel!
  @IBOutlet weak var orderIdLabel: UILabel!
  @IBOutlet weak var estimateTimeLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var statusOrderLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    statusView.layer.cornerRadius = statusView.bounds.height / 2
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func loadData(order: OrderModel) {
    orderImageView.loadImage(fromUrl: URL(string: order.image))
    ordernameLabel.text = order.name
    orderIdLabel.text = String(order.orderID.prefix(10))
    estimateTimeLabel.text = order.arrived
    statusOrderLabel.text = order.status
    priceLabel.text = String(order.price) + "USD"
  }
}
