//
//  ProfileViewController.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 4/8/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {
  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var bottomBorderEmailView: UIView!
  @IBOutlet weak var phoneTextField: UITextField!
  @IBOutlet weak var bottomBorderPhoneView: UIView!
  @IBOutlet weak var pointLabel: UILabel!
  @IBOutlet weak var avatarImageView: UIImageView!
  
  @IBOutlet weak var bottomBorderUserNameView: UIView!
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var editButton: UIButton!
  private var viewModel: ProfileViewModelType!
  let imagePicker = UIImagePickerController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel = ProfileViewModel()
    initView()
    initObservable()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = false
  }
  
  
  @IBAction func handleBack(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func handleEdit(_ sender: Any) {
    if isEditing {
      if viewModel.phone.value != UserModel.currentUser.phone {
        verifyPhonenumber()
      } else {
        self.showLoadingIndicator()
        updateProfile()
      }
    } else {
      isEditing = !isEditing
      editMode(isEditing)
    }
  }
  
  @IBAction func handleChangeAvatar(_ sender: Any) {
    imagePicker.delegate = self
    imagePicker.sourceType = .photoLibrary
    imagePicker.allowsEditing = true
    present(imagePicker, animated: true, completion: nil)
  }
  
}

extension ProfileViewController {
  func initView() {
    pointLabel.text = "\(UserModel.currentUser.point)"
    editMode(isEditing)
    emailTextField.text = UserModel.currentUser.email
    phoneTextField.text = UserModel.currentUser.phone
    usernameTextField.text = UserModel.currentUser.username
    avatarImageView.loadImage(fromUrl: URL(string: UserModel.currentUser.avatar), placeholder: UIImage(named: "user_default"))
  }
  
  func initObservable() {
    emailTextField.rx.text.map { $0 ?? "" }.bind(to: viewModel.email).disposed(by: self.disposeBag)
    phoneTextField.rx.text.map { $0 ?? "" }.bind(to: viewModel.phone).disposed(by: self.disposeBag)
    usernameTextField.rx.text.map { $0 ?? "" }.bind(to: viewModel.userName).disposed(by: self.disposeBag)
  }
  
  func editMode(_ edit: Bool) {
    bottomBorderEmailView.isHidden = !edit
    bottomBorderPhoneView.isHidden = !edit
    bottomBorderUserNameView.isHidden = !edit
    phoneTextField.isUserInteractionEnabled = edit
    emailTextField.isUserInteractionEnabled = edit
    usernameTextField.isUserInteractionEnabled = edit
    editButton.setTitle(edit ? "Save" : "Edit", for:  .normal)
  }
  
  func updateProfile() {
    AuthenApi.updateProfile(username: viewModel.userName.value, phone: viewModel.phone.value, email: viewModel.email.value).subscribe(onNext: { [weak self] (user) in
      guard let self = self else { return }
      self.hideLoadingIndicator()
      self.isEditing = !self.isEditing
      UserModel.currentUser = user
      self.editMode(self.isEditing)
      }, onError: { [weak self] (error) in
        guard let self = self else { return }
        self.hideLoadingIndicator()
        if let err = error as? ErrorMessage {
          self.view.makeToast("\(err.message)")
        } else {
          self.view.makeToast("\(error.localizedDescription)")
        }
    }, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
  }
  
  private func verifyPhonenumber() {
    self.showLoadingIndicator()
    let phone = "+1\(viewModel.phone.value)"
    AuthenApi.verifyPhonenumber(phoneNumber: phone)
      .subscribe(onNext: { [weak self] verifyId in
        guard let self = self else { return }
        UserDefaults.standard.set(verifyId, forKey: "authVerificationID")
        self.updateProfile()
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
  
  func updataAvatar(url: URL?) {
    if let url = url {
      AuthenApi.updateAvata(url: url.absoluteString)
        .subscribe(onNext: { [weak self] (user) in
          guard let _ = self else { return }
          UserModel.currentUser = user
      }, onError: { (error) in
        print("\(error.localizedDescription)")
      }, onCompleted: nil, onDisposed: nil)
        .disposed(by: self.disposeBag)
    }
  }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      print("\(String(describing: pickedImage.images))")
      if let image = pickedImage.hightQualityResized(toWidth: 200)?.saveImageToDisk() {
        _ = AuthenApi.uploadFile(path: image, saveAtPath: "user/avatar/")
          .subscribe(onNext: { [weak self] url in
            guard let self = self else { return }
            self.updataAvatar(url: url)
            self.avatarImageView.loadImage(fromUrl: url)
            self.view.makeToast("Avatar changed!!")
        }, onError: { [weak self] (error) in
          guard let self = self else { return }
          self.hideLoadingIndicator()
          if let err = error as? ErrorMessage {
            self.view.makeToast("\(err.message)")
          } else {
            self.view.makeToast("\(error.localizedDescription)")
          }
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
      }
    }
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
}
