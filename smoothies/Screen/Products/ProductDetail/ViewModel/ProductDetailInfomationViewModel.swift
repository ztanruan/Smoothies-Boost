//
//  ProductDetailInfomationViewModel.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 3/18/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit

protocol ProductDetailInfomationViewModelType {
  var image: String { get }
  var name: String { get }
  var rating: Double { get }
  var minute: Int { get }
  var cate: String { get }
}

class ProductDetailInfomationViewModel: ProductDetailInfomationViewModelType {
  var image: String = ""
  var name: String = ""
  var rating: Double = 0.0
  var minute: Int = 0
  var cate: String = ""
  
  init(image: String, name: String, rating: Double, minute: Int, cate: String) {
    self.image = image
    self.rating = rating
    self.minute = minute
    self.cate = cate
    self.name = name
  }
}
