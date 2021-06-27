//
//  ServingsTableViewCell.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 3/22/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit

class ServingsTableViewCell: UITableViewCell {
  
  @IBOutlet weak var valueLabel: UILabel!
  private var currentIndex: Int = 0
  private var tempServed: [Int] = []
  
  var callBack: ((_ value: Int) -> Void)?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  @IBAction func handleMinus(_ sender: Any) {
    if currentIndex > 0 {
      currentIndex -= 1
      callBack?(tempServed[currentIndex])
      valueLabel.text = "\(tempServed[currentIndex])"
    }
  }
  
  @IBAction func handleAdd(_ sender: Any) {
    if currentIndex < (tempServed.count - 1) {
      currentIndex += 1
      callBack?(tempServed[currentIndex])
      valueLabel.text = "\(tempServed[currentIndex])"
    }
  }
  
  func loadCell(served: [Int], defaulValue: Int) {
    served.enumerated().forEach { (index, served) in
      if served == defaulValue {
        currentIndex = index
      }
    }
    tempServed = served
    if served.count > 0 {
      valueLabel.text = "\(defaulValue)"
    }
  }
}
