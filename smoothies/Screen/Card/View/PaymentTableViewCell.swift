//
//  PaymentTableViewCell.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 4/20/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit
import Stripe

class PaymentTableViewCell: UITableViewCell {
  @IBOutlet weak var cardImageView: UIImageView!
  @IBOutlet weak var iconDefault: UIImageView!
  @IBOutlet weak var cardInfoLabel: UILabel!
  @IBOutlet weak var line: UIView!

  let normalColor: UIColor = UIColor(red: 0/255, green: 179/255, blue: 251/255, alpha: 1)
  let normalAttributeColor: UIColor = UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1)
  let selectedColor: UIColor = UIColor(red: 0/255, green: 179/255, blue: 251/255, alpha: 1)
  let selectedAttributeColor: UIColor = UIColor(red: 0/255, green: 179/255, blue: 251/255, alpha: 1)
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func loadData(card: STPCard?, isShowLine: Bool, isDefault: Bool = false) {
    let color = isDefault ? normalColor : normalAttributeColor
    let colorAttribute = isDefault ? selectedAttributeColor : normalAttributeColor
    if let card = card {
      cardInfoLabel.textColor = color
      cardImageView.image = card.templateImage
      cardImageView.tintColor = colorAttribute
      
      let name = (card.allResponseFields["brand"] as? String) ?? ""
      cardInfoLabel.attributedText = setAttribute(name: name, attributeText: " Ending In ", cardnumber: card.last4, mainColor: color, attributeColor: colorAttribute)
    } else {
      cardInfoLabel.textColor = selectedColor
      cardImageView.image = UIImage(named: "icon_add")
      cardInfoLabel.text = "Add New Card..."
    }
    
    iconDefault.image = isDefault ? UIImage(named: "stp_icon_checkmark") : nil
    iconDefault.tintColor = colorAttribute
    line.isHidden = !isShowLine
  }
  
  func setAttribute(name: String, attributeText: String, cardnumber: String, mainColor: UIColor, attributeColor: UIColor) -> NSAttributedString {
    let middleAttributeColor = [ NSAttributedString.Key.foregroundColor: attributeColor ]
    let mainAttributeColor = [ NSAttributedString.Key.foregroundColor: mainColor ]
    
    let nameAttribute = NSAttributedString(string: name, attributes: mainAttributeColor)
    let middleAttribute = NSAttributedString(string: attributeText, attributes: middleAttributeColor)
    let cardnumberAttribute = NSAttributedString(string: cardnumber, attributes: mainAttributeColor)
    
    let combination = NSMutableAttributedString()
    combination.append(nameAttribute)
    combination.append(middleAttribute)
    combination.append(cardnumberAttribute)
    
    return combination
  }
}
