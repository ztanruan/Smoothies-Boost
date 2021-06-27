//
//  ProductDetailInfomationViewController.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 3/14/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit
import Cosmos
import Kingfisher

class ProductDetailInfomationViewController: UIViewController {
  @IBOutlet private weak var itemImageView: UIImageView!
  @IBOutlet private weak var nameLabel: UILabel!
  @IBOutlet private weak var cosmosView: CosmosView!
  @IBOutlet private weak var minuteLabel: UILabel!
  @IBOutlet private weak var cateLabel: UILabel!
  
  private var viewModel: ProductDetailInfomationViewModelType!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initView()
  }
}

extension ProductDetailInfomationViewController {
  private func initView() {
    print("viewmodel \(viewModel.image)")
    itemImageView.loadImage(fromUrl: URL(string: viewModel.image))
    nameLabel.text = viewModel.name
    cosmosView.rating = Double(viewModel.rating)
    minuteLabel.text = "\(viewModel.minute)"
    cateLabel.text = viewModel.cate
  }
  
  func initVC(viewModel: ProductDetailInfomationViewModel) {
    self.viewModel = viewModel
  }
}
