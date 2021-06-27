//
//  SlideMenuViewModel.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 4/26/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit

class ItemSlideMenu {
  var icon: UIImage?
  var name: String?
  var type: ItemSlideMenuType
  var isActive: Bool = false
  
  init(icon: UIImage?, name: String?, type: ItemSlideMenuType, isActive: Bool = false) {
    self.icon = icon
    self.name = name
    self.type = type
    self.isActive = isActive
  }
}

protocol SlideMenuViewModelType {
  var itemSlideMenus: [ItemSlideMenu] { get }
}

class SlideMenuViewModel: SlideMenuViewModelType {
  var itemSlideMenus: [ItemSlideMenu] = []
  init(type: ItemSlideMenuType) {
    itemSlideMenus.append(ItemSlideMenu(icon: UIImage(named: "smoothie"), name: "Smoothies", type: .smoothies, isActive: type == .smoothies))
    itemSlideMenus.append(ItemSlideMenu(icon: UIImage(named: "profile"), name: "Account", type: .account, isActive: type == .account))
    itemSlideMenus.append(ItemSlideMenu(icon: UIImage(named: "shopping-bag"), name: "My Orders", type: .myorder, isActive: type == .myorder))
    
    itemSlideMenus.append(ItemSlideMenu(icon: UIImage(named: "place"), name: "My Location", type: .location, isActive: type == .location))
    
    itemSlideMenus.append(ItemSlideMenu(icon: UIImage(named: "aboutus"), name: "About Us", type: .about, isActive: type == .about))
    
    if UserModel.currentUser.role == RoleApp.superAdmin.rawValue {
      itemSlideMenus.append(ItemSlideMenu(icon: UIImage(named: "file"), name: "Manage", type: .manage))
    }
    itemSlideMenus.append(ItemSlideMenu(icon: UIImage(named: "logout"), name: "Sign Out", type: .signout, isActive: type == .signout))
  }
}
