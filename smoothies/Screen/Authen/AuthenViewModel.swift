//
//  AuthenViewModel.swift
//  smoothie
//
//  Created by zhen xin  tan ruan on 4/6/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import RxCocoa
import RxSwift


// Define the variable that we are going to use in the auth class to authenticate users

protocol AuthenViewModelType {
  var userName: Variable<String> { get }
  var email: Variable<String> { get }
  var phonenumber: Variable<String> { get }
  func validateForLogin() -> String?
  func validateForPhone() -> String?
}

class AuthenViewModel: BaseViewModel, AuthenViewModelType {
  var userName: Variable<String> = Variable<String>("")
  var email: Variable<String> = Variable<String>("")
  var phonenumber: Variable<String> = Variable<String>("")
  
  func validateForLogin() -> String? {
    if userName.value.isBlank { return "User name required" }
    if email.value.isBlank { return "Email required" }
    if !email.value.isEmailValid() { return "Email invalid" }
    if !phonenumber.value.isPhoneNumberValid(number: 10) { return "Phone number required" }
    return nil
  }
  
  func validateForPhone() -> String? {
    if !phonenumber.value.isPhoneNumberValid(number: 10) { return "Phone number required" }
    return nil
  }
}
