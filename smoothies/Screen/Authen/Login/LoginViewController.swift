//
//  LoginViewController.swift
//  smoothie
//
//  Created by zhen xin  tan ruan on 4/3/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import RxSwift
import RxCocoa

class LoginViewController: BaseViewController {
  
  @IBOutlet weak var userNameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
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
  
  @IBAction func handleSignIn(_ sender: Any) {
    if let message = viewModel.validateForPhone() {
      self.view.makeToast(message)
      return
    }
    verifyPhonenumber()
//    AuthenApi.getUserDetailId()
//      .subscribe(onNext: { [weak self] user in
//        UserModel.currentUser = user
//        self?.changeRoot()
//      }, onError: nil, onCompleted: nil, onDisposed: nil)
  }
  
  @IBAction func handleSignUp(_ sender: Any) {
    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignupViewController")
    navigationController?.pushViewController(vc, animated: true)
  }
}

extension LoginViewController {
  
  func initVC(viewModel: AuthenViewModel) {
    self.viewModel = viewModel
  }
  
  private func initView() {
    userNameTextField.setColorForPlaceholder(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    
    UserDefaults.standard.setValue(true, forKey: "isShowFlash")
  }
  
  private func initObservable() {
    userNameTextField.rx.text.map { $0 ?? "" }.bind(to: viewModel.phonenumber).disposed(by: self.disposeBag)
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
  
  private func showConfirmOTP() {
    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
    vc.confirmCallBack = { [weak self] value in
      guard let self = self, let otp = value else { return }
      self.login(otp: otp)
    }
    self.present(vc, animated: true, completion: nil)
  }
  
  private func login(otp: String) {
    self.showLoadingIndicator()
    let phone = Constants.FirebaseConstant.phonePrefix + "\(viewModel.phonenumber.value)"
    AuthenApi.signin(phone: phone, otp: otp)
      .subscribe(onNext: { [weak self] (user) in
        guard let self = self else { return }
        UserModel.currentUser = user
        self.hideLoadingIndicator()
        self.changeRoot()
        }, onError: { [weak self] (error) in
          guard let self = self else { return }
          self.hideLoadingIndicator()
          if let err = error as? ErrorMessage {
            self.view.makeToast("\(err.message)")
          } else {
            self.view.makeToast("\(error.localizedDescription)")
          }
        }, onCompleted: nil, onDisposed: nil)
      .disposed(by: self.disposeBag)
  }
  
  private func changeRoot() {
    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListProductViewController")
    let navigationVC = UINavigationController(rootViewController: vc)
    appDelegate.changeRootVC(vc: navigationVC, animation: true)
  }
}
