//
//  Protocols.swift
//  adidi-partner
//
//  Created by zhen xin  tan ruan on 3/16/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit

// MARK: - ReusableView
// Template code for Ibloadable view controller

public protocol ReusableView: class { }

extension ReusableView where Self: UIView {
  
  static var reuseIdentifier: String {
    return String(describing: self)
  }
}

// MARK: - NibloadableView
public protocol NibloadableView: class { }

extension NibloadableView where Self: UIView {
  
  static var nibName: String {
    return String(describing: self)
  }
}

// MARK: - ConfigurableCell
protocol ConfigurableCell {
  
  associatedtype DataType
  func loadCellWithData(_ data: DataType)
}

// MARK: - CellConfigurator
protocol CellConfigurator {
  
  static var reuseId: String { get }
  func configure(cell: UIView)
}

