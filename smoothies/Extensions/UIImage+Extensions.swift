//
//  UIImage+Extensions.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 3/20/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit

 // Exntension func to store image in the firebase Database
 // Defind and Initialize the parameter for imagee in the App

extension UIImage {
  func hightQualityResized(toWidth width: CGFloat) -> UIImage? {
    let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
    return UIGraphicsImageRenderer(size: canvasSize).image { _ in
      self.draw(in: CGRect(origin: .zero, size: canvasSize))
    }
  }
  
    // Save imagee func
    
  func saveImageToDisk(index: Int = 0) -> URL {
    let fileManager = FileManager.default
    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("image_\(index).jpg")
    let imageData = self.pngData()
    fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    return URL(fileURLWithPath: paths)
  }
}
