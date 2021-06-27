//
//  SignupViewController.swift
//  smoothie
//
//  Created by zhen xin  tan ruan on 4/5/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit
import Toast_Swift
import FirebaseAuth

class SignupViewController: BaseViewController {
  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var userNameTextField: UITextField!
  @IBOutlet weak var phoneNumberTextField: UITextField!
  
  private var viewModel: AuthenViewModelType!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initVC(viewModel: AuthenViewModel())
    initView()
    initObservable()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    clearNavigationBar()
    setupNavigationBarTitleColor(color: .white)
  }
  
  @IBAction func handleSignup(_ sender: Any) {
    if let message = viewModel.validateForLogin() {
      self.view.makeToast(message)
      return
    }
    verifyPhonenumber()    
  }

  @IBAction func handleSignIn(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
}

extension SignupViewController {
  
  func initVC(viewModel: AuthenViewModel) {
    self.viewModel = viewModel
  }
  
  private func initView() {
    userNameTextField.setColorForPlaceholder(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    emailTextField.setColorForPlaceholder(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    phoneNumberTextField.setColorForPlaceholder(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
  }
  
  private func initObservable() {
    userNameTextField.rx.text.map { $0 ?? "" }.bind(to: viewModel.userName).disposed(by: self.disposeBag)
    emailTextField.rx.text.map { $0 ?? "" }.bind(to: viewModel.email).disposed(by: self.disposeBag)
    phoneNumberTextField.rx.text.map { $0 ?? "" }.bind(to: viewModel.phonenumber).disposed(by: self.disposeBag)
  }
  
  private func verifyPhonenumber() {
    self.showLoadingIndicator()
    let phone = Constants.FirebaseConstant.phonePrefix + "\(viewModel.phonenumber.value)"
    AuthenApi.verifyPhonenumber(phoneNumber: phone)
      .subscribe(onNext: { [weak self] verifyId in
        guard let self = self else { return }
        UserDefaults.standard.set(verifyId, forKey: "authVerificationID")
        self.hideLoadingIndicator()
        self.showConfirmOTP()
      }, onError: { [weak self] error in
        guard let self = self else { return }
        self.hideLoadingIndicator()
        if let err = error as? ErrorMessage {
          self.view.makeToast("\(err.message)")
        } else {
          self.view.makeToast("\(error.localizedDescription)")
        }
        
      }, onCompleted: nil, onDisposed: nil)
      .disposed(by: disposeBag)
  }
  
  private func authen(user: User) {
    AuthenApi.getListUserId()
      .subscribe(onNext: { [weak self] userId in
        guard let self = self else { return }
        let isContent = userId.contains(user.uid)
        if isContent {
          self.view.makeToast("User exist!!")
        } else {
          self.signupToFirebase(userAuth: user)
        }
    }, onError: { [weak self] error in
      guard let self = self else { return }
      self.view.makeToast(error.localizedDescription)
    }, onCompleted: nil, onDisposed: nil)
      .disposed(by: self.disposeBag)
  }
  
  private func login(otp: String) {
    AuthenApi.signup(otp: otp, phone: viewModel.phonenumber.value, username: viewModel.userName.value)
      .subscribe(onNext: { [weak self] (user) in
        guard let self = self else { return }
        self.authen(user: user)
    }, onError: { [weak self] (error) in
      guard let self = self else { return }
      self.view.makeToast(error.localizedDescription)
    }, onCompleted: nil, onDisposed: nil)
      .disposed(by: self.disposeBag)
  }
  
  private func signupToFirebase(userAuth: User) {    
    AuthenApi.updateInformation(user: userAuth, username: viewModel.userName.value, phone: viewModel.phonenumber.value, email: viewModel.email.value)
      .subscribe(onNext: { [weak self] user in
        guard let self = self else { return }
        UserModel.currentUser = user
        self.changeRoot()
      }, onError: {[weak self] error in
        guard let self = self else { return }
        if let err = error as? ErrorMessage {
          self.view.makeToast("\(err.message)")
        } else {
          self.view.makeToast("\(error.localizedDescription)")
        }
      }, onCompleted: nil, onDisposed: nil)
      .disposed(by: self.disposeBag)
  }
  
  
  
  private func showConfirmOTP() {
    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
    vc.confirmCallBack = { [weak self] value in
      guard let self = self, let otp = value else { return }
      self.login(otp: otp)
    }
    self.present(vc, animated: true, completion: nil)
  }
  
  private func changeRoot() {
    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListProductViewController")
    let navigationVC = UINavigationController(rootViewController: vc)
    appDelegate.changeRootVC(vc: navigationVC, animation: true)
  }
}
