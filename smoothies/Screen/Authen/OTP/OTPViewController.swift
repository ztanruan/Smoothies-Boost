//
//  OTPViewController.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 4/5/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit
import DigitInputView

class OTPViewController: BaseViewController {
  
  @IBOutlet weak var digitInputView: DigitInputView!
  
  var confirmCallBack: ((_ value: String?) -> Void)?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    initView()
  }
  
  @IBAction func handleOk(_ sender: Any) {
    confirmCallBack?(digitInputView.text)
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func handleCancel(_ sender: Any) {
    confirmCallBack?(nil)
    dismiss(animated: true, completion: nil)
  }
}

extension OTPViewController {
  func initView() {
    digitInputView.numberOfDigits = 6
    digitInputView.bottomBorderColor = .purple
    digitInputView.nextDigitBottomBorderColor = .red
    digitInputView.textColor = .purple
    digitInputView.acceptableCharacters = "0123456789"
    digitInputView.keyboardType = .decimalPad
    digitInputView.animationType = .spring
    digitInputView.keyboardAppearance = .dark
  }
}
