//
//  UICollectionView+Extensions.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 4/27/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit


    // Extension for user infromation view controller

extension UICollectionView {
  func register<T: UICollectionViewCell> (_: T.Type) where T: ReusableView, T: NibloadableView  {
    let nib = UINib(nibName: T.nibName, bundle: nil)
    register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
  }
  
  func dequeuReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath)  -> T where T: ReusableView {
    guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
      fatalError("could not dequeue cell with identifier: \(T.reuseIdentifier)")
    }
    
    return cell
  }
}
