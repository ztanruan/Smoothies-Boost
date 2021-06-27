//
//  SplashViewController.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 4/21/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit
import RxSwift
import FirebaseAuth

class SplashViewController: BaseViewController {
  var products = [ProductModel]()
  
  override func viewDidLoad() {
    super.viewDidLoad()

  }
  
  @IBAction func handleStart(_ sender: Any) {
    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TutorialViewController")
    present(vc, animated: true, completion: nil)
  }
  
  func getListProducts() {
    ProductApi.getListProducts()
      .subscribe(onNext: { products in
        print("success")
        self.products = products
      }, onError: { error in
        print("errorror")
      }, onCompleted: nil, onDisposed: nil)
      .disposed(by: disposeBag)
  }
  
  func likeProduct(product: ProductModel) {
    ProductApi.likeProduct(product: product)
      .subscribe(onNext: { isLiked in
        print("isliked \(isLiked)")
      }, onError: { error in
        print("error")
      }, onCompleted: nil, onDisposed: nil)
      .disposed(by: disposeBag)
  }
}
