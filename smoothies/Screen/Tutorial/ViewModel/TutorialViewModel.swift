//
//  TutorialViewModel.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 4/21/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

 // Define the Initial View Controller of the App

import UIKit

class TutorialModel: NSObject {
  var title: String?
  var image: UIImage?
  var descriptionInfor: String?
  
  override init() {
    super.init()
  }
  
  init(title: String, image: UIImage?, desciption: String) {
    self.title = title
    self.image = image
    self.descriptionInfor = desciption
  }
}

protocol TutorialViewModelType {
  var tutorials: [TutorialModel] { get }
}

class TutorialViewModel: TutorialViewModelType {
  var tutorials: [TutorialModel] = []
  
  init() {
    tutorials.append(TutorialModel(title: "Discover smoothies", image: UIImage(named: "user_default"), desciption: "Discover thousands of tasty smoothies for any drink enthusiast"))
    tutorials.append(TutorialModel(title: "Choose recipe", image: UIImage(named: "icon_choose_recipe"), desciption: "Choose your favorite smoothie and see full details on the recipe and preparation"))
    tutorials.append(TutorialModel(title: "Next day delivery", image: UIImage(named: "icon_delivery"), desciption: "Order all your favorite smoothie ingredients in one click. Next day delivery guaranteed"))
  }
}
