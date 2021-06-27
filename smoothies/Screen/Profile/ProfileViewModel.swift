//
//  ProfileViewModel.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 4/5/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import RxCocoa
import RxSwift

protocol ProfileViewModelType {
  var phone: Variable<String> { get }
  var email: Variable<String> { get }
  var userName: Variable<String> { get }
}

class ProfileViewModel: ProfileViewModelType {
  var phone: Variable<String> = Variable<String>("")
  var email: Variable<String> = Variable<String>("")
  var userName: Variable<String> = Variable<String>("")
}
