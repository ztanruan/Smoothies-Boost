// ChangePasswordViewController.swift
// smoothies
//
//  Created by zhen xin  tan ruan on 4/23/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit

class ChangePasswordViewController: BaseViewController {

  // MARK: - IBOutlet

  // MARK: - Variables
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    initView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    layoutView()
  }
  @IBAction func handleBack(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
}

// MARK: - UI
extension ChangePasswordViewController {
  private func initView() {
    
  }
  
  private func layoutView() {
    
  }
}
