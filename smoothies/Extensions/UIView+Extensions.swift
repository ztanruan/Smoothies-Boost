//
//  UIView+Extensions.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 3/17/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit

// Online Template file to customize view controller (Reference)
// Customize template to change UI Design of view controller

extension UIView {
  @IBInspectable var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
      clipsToBounds = true
    }
  }
  
  @IBInspectable var borderColor: UIColor? {
    get {
      guard let borderColor = layer.borderColor else {
        return nil
      }
      
      return UIColor(cgColor: borderColor)
    }
    set {
      layer.borderColor = newValue?.cgColor
    }
  }
  
  @IBInspectable var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layer.borderWidth = newValue
    }
  }
  
  @IBInspectable var masksToBounds: Bool{
    get{
      return layer.masksToBounds
    }
    set{
      layer.masksToBounds = newValue
    }
  }
  
  
  @IBInspectable var shadowOffset: CGSize{
    get{
      return layer.shadowOffset
    }
    set{
      layer.shadowOffset = newValue
    }
  }
  
  @IBInspectable var shadowColor: UIColor{
    get{
      return UIColor(cgColor: layer.shadowColor!)
    }
    set{
      layer.shadowColor = newValue.cgColor
    }
  }
  
  @IBInspectable var shadowRadius: CGFloat{
    get{
      return layer.shadowRadius
    }
    set{
      layer.shadowRadius = newValue
    }
  }
  
  @IBInspectable var shadowOpacity: Float{
    get{
      return layer.shadowOpacity
    }
    set{
      layer.shadowOpacity = newValue
    }
  }
    
    // Func to create the UI Design image/ place holders
  
  func addDashedBorder() {
    let color = UIColor.red.cgColor
    
    let shapeLayer:CAShapeLayer = CAShapeLayer()
    let frameSize = self.frame.size
    let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
    
    shapeLayer.bounds = shapeRect
    shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.strokeColor = color
    shapeLayer.lineWidth = 2
    shapeLayer.lineJoin = CAShapeLayerLineJoin.round
    shapeLayer.lineDashPattern = [6,3]
    shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
    
    self.layer.addSublayer(shapeLayer)
  }
  
  func drawDottedLine(start p0: CGPoint, end p1: CGPoint) {
    let shapeLayer = CAShapeLayer()
    shapeLayer.strokeColor = UIColor.lightGray.cgColor
    shapeLayer.lineWidth = 1
    shapeLayer.lineDashPattern = [7, 3] // 7 is the length of dash, 3 is length of the gap.
    
    let path = CGMutablePath()
    path.addLines(between: [p0, p1])
    shapeLayer.path = path
    self.layer.addSublayer(shapeLayer)
  }
  
  func setShadowWithColor(_ color: UIColor? = UIColor.lightGray, _ opacity: Float? = 1.0, _ offset: CGSize? = CGSize.zero, _ radius: CGFloat? = 2.0, _ viewCornerRadius: CGFloat? = 2.0) {
    layer.shadowColor = color?.cgColor
    layer.shadowOpacity = opacity!
    layer.shadowOffset = offset!
    layer.shadowRadius = radius!
  }
}
