//
//  BaseViewController.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 4/23/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import RxSwift
import RxCocoa
import JGProgressHUD

class BaseViewController: UIViewController {
  var disposeBag = DisposeBag()
  let appDelegate = UIApplication.shared.delegate as! AppDelegate
  private let hud = JGProgressHUD(style: .dark)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBarFont()
    
  }
  
  func showLoadingIndicator(title: String = "Loading...") {
    hud.textLabel.text = title
    hud.position = .center
    hud.layoutMargins = UIEdgeInsets(top: -40, left: 0, bottom: 0, right: 0)
    hud.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    if let navigationView = self.navigationController?.view {
      hud.show(in: navigationView)
    } else {
      hud.show(in: self.view)
    }
  }
  
  func hideLoadingIndicator() {
   hud.dismiss(animated: true)
  }
  
  private func setupNavigationBarFont() {
    let textAttributes = [NSAttributedString.Key.font: UIFont.RalewayMedium(18)]
    navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
  }
  
  func setNavigationBarHidden(_ hidden: Bool, animated: Bool) {
    navigationController?.setNavigationBarHidden(hidden, animated: animated)
  }
  
  func setupNavigationBarTitleColor(color: UIColor) {
    let textAttributes = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: UIFont.RalewayMedium(18)]
    navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
  }
  
  func clearNavigationBar(isClear: Bool = true) {
    navigationController?.navigationBar.shadowImage = isClear ? UIImage() : nil
    navigationController?.navigationBar.setBackgroundImage(isClear ? UIImage() : nil, for: UIBarMetrics.default)
  }
  
  func setupNavigationBarColor(color: UIColor) {
    navigationController?.navigationBar.backgroundColor = color
  }
  
  func setStatusBarBackgroundColor(color: UIColor, animation: Bool = true) {
    guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
    
    if animation {
      UIView.transition(with: statusBar, duration: 0.25, options: .transitionCrossDissolve, animations: {
        statusBar.backgroundColor = color
      }, completion: nil)
    } else {
      statusBar.backgroundColor = color
    }
  }
}
