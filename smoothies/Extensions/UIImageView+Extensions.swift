//
//  UIImageView+Extensions.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 3/21/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//


 // Import UIKit and Kingfisher Library
 // App UI Design extension func

import UIKit
import Kingfisher

extension UIImageView {
  func loadImage(fromUrl: URL?, placeholder: UIImage? = nil) {
    if let imageURL = fromUrl {
      self.kf.setImage(
        with: imageURL,
        placeholder: placeholder,
        options: [
          .scaleFactor(UIScreen.main.scale),
          .transition(.fade(1)),
          .cacheOriginalImage
        ])
      {
        result in
        switch result {
        case .success(let value):
          print("Task done for: \(value.source.url?.absoluteString ?? "")")
        case .failure(let error):
          print("Job failed: \(error.localizedDescription)")
        }
      }
    }
  }
  
  func setTintColor(_ color: UIColor) {
    if let _ = self.image {
      self.image = self.image!.withRenderingMode(.alwaysTemplate)
      self.tintColor = color
    }
  }
}
