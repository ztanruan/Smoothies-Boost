//
//  AuthenApi.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 3/20/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//



// Template from online from Firebase Library
// Stripe Library template

import FirebaseDatabase
import FirebaseAuth
import CodableFirebase
import RxSwift
import FirebaseFunctions
import FirebaseStorage

class AuthenApi {
  static let ref = Database.database().reference()
  static let dispose = DisposeBag()
  static let userRef = "users"
  
  static func verifyPhonenumber(phoneNumber: String) -> Observable<String?> {
    return Observable<String?>.create { sender in
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
              if let error = error {
                sender.onError(ErrorMessage(message: error.localizedDescription))
              } else {
                sender.onNext(verificationID)
              }
            }
      return Disposables.create()
    }
  }
  
  static func signup(otp: String, phone: String, username: String) -> Observable<User> {
    return Observable<User>.create { sender in
      
      let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
      let credential = PhoneAuthProvider.provider().credential(
        withVerificationID: verificationID ?? "",
        verificationCode: otp)
      Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
        if let error = error {
          sender.onError(error)
          return
        }
        guard let userAuth = authResult?.user else { return }
        
        sender.onNext(userAuth)
      }
      return Disposables.create()
    }
  }
  
  static func getListUserId() -> Observable<[String]> {
    return Observable<[String]>.create { sender in
      
      ref.child(userRef).observe(.value, with: { snapshot in
        guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else { return }
        var users: [UserModel] = []
        snapshots.forEach({
          do {
            guard let value = $0.value else { return }
            let user = try FirebaseDecoder().decode(UserModel.self, from: value)
            users.append(user)
          } catch let error {
            sender.onError(error)
          }
        })
        let userId = users.compactMap({ $0.userID })
        sender.onNext(userId)
      })
      
      return Disposables.create()
    }
  }
  
  static func signin(phone: String, otp: String) -> Observable<UserModel> {
    return Observable<UserModel>.create { sender in
      
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        let credential = PhoneAuthProvider.provider().credential(
          withVerificationID: verificationID ?? "",
          verificationCode: otp)
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
          if let error = error {
            sender.onError(error)
            return
          }
          guard let userAuth = authResult?.user else { return }
          _ = getUserDetail(user: userAuth)
            .subscribe(onNext: { (user) in
            sender.onNext(user)
          }, onError: { (error) in
            sender.onError(error)
          }, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.dispose)
      }
      
      return Disposables.create()
    }
  }
  
  static func updateInformation(user: User, username: String, phone: String, email: String) -> Observable<UserModel> {
    return Observable<UserModel>.create { sender in
      
      let userParam = [
        "user_id": user.uid,
        "email": email,
        "username": username,
        "phone": phone,
        "avatar": "",
        "point": 0,
        "role": 0,
        "token": user.refreshToken ?? "",
        "fcmtoken": Constants.FirebaseConstant.token
        ] as [String : Any]
      
      ref.child(userRef).child(user.uid).setValue(userParam)
      ref.child(userRef).child(user.uid).observeSingleEvent(of: DataEventType.value, with: { snapshot in
        guard let value = snapshot.value else { return }
        do {
          let userModel = try FirebaseDecoder().decode(UserModel.self, from: value)
          sender.onNext(userModel)
        } catch let error {
          sender.onError(ErrorMessage(message: error.localizedDescription))
        }
      })
      
      return Disposables.create()
    }
  }
  
  static func getUserDetail(user: User) -> Observable<UserModel> {
    return Observable<UserModel>.create { sender in
      ref.child(userRef).child(user.uid)
        .observeSingleEvent(of: DataEventType.value, with: { snapshot in
          guard let value = snapshot.value else { return }
          do {
            let userModel = try FirebaseDecoder().decode(UserModel.self, from: value)
            sender.onNext(userModel)
          } catch let error {
            sender.onError(ErrorMessage(message: error.localizedDescription))
          }
        })
      return Disposables.create()
    }
  }
  
  static func getUserDetailId() -> Observable<UserModel> {
    return Observable<UserModel>.create { sender in

    ref.child(userRef).child("gxEOOkBQmTXhiG4RkNY6zmHfxio1")
      .observeSingleEvent(of: DataEventType.value, with: { snapshot in
        guard let value = snapshot.value else { return }
        do {
          let userModel = try FirebaseDecoder().decode(UserModel.self, from: value)
          sender.onNext(userModel)
        } catch let error {
          sender.onError(ErrorMessage(message: error.localizedDescription))
        }
      })
    return Disposables.create()
    }
  }
  
  static func changeEmail(newEmail: String) -> Observable<UserModel> {
    return Observable<UserModel>.create { sender in
      Auth.auth().currentUser?.updateEmail(to: newEmail, completion: { error in
        if error != nil {
          sender.onError(ErrorMessage(message: "Change email fail"))
        } else {
          updateEmail(email: newEmail)
            .subscribe(onNext: { userModel in
              sender.onNext(userModel)
            }, onError: { error in
              let errorModel = error as! ErrorMessage
              sender.onError(errorModel)
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: dispose)
        }
      })
      return Disposables.create()
    }
  }
  
  static func updateEmail(email: String) -> Observable<UserModel> {
    return Observable<UserModel>.create { sender in
      let userid = UserModel.currentUser.userID
      ref.child(userRef).child(userid).updateChildValues(["email" : email])
      ref.child(userRef).child(userid).observeSingleEvent(of: .value, with: { snapshot in
        guard let value = snapshot.value else { return }
        do {
          let userModel = try FirebaseDecoder().decode(UserModel.self, from: value)
          sender.onNext(userModel)
        } catch let error {
          sender.onError(ErrorMessage(message: error.localizedDescription))
        }
      })
      return Disposables.create()
    }
  }
  
  static func updateProfile(username: String, phone: String, email: String) -> Observable<UserModel> {
    return Observable<UserModel>.create { sender in
      let userid = UserModel.currentUser.userID

      ref.child(userRef).child(userid).updateChildValues(["username": username, "phone": phone, "email": email])
      ref.child(userRef).child(userid).observeSingleEvent(of: .value, with: { snapshot in
        guard let value = snapshot.value else { return }
        do {
          let userModel = try FirebaseDecoder().decode(UserModel.self, from: value)
          sender.onNext(userModel)
        } catch let error {
          sender.onError(ErrorMessage(message: error.localizedDescription))
        }
      })
      return Disposables.create()
    }
  }
  
  static func signout() {
    do{
      try Auth.auth().signOut()
      //      self.performSegueWithIdentifier("logoutSegue", sender: self)
    }catch{
      print("Error while signing out!")
    }
  }
  
  static func updateAvata(url: String) -> Observable<UserModel> {
    return Observable<UserModel>.create { sender in
      let userid = UserModel.currentUser.userID

      ref.child(userRef).child(userid).updateChildValues(["avatar": url])
      ref.child(userRef).child(userid).observeSingleEvent(of: .value, with: { snapshot in
        guard let value = snapshot.value else { return }
        do {
          let userModel = try FirebaseDecoder().decode(UserModel.self, from: value)
          sender.onNext(userModel)
        } catch let error {
          sender.onError(ErrorMessage(message: error.localizedDescription))
        }
      })
      return Disposables.create()
    }
  }
  
  static func uploadFile(path: URL, saveAtPath: String) -> Observable<URL?> {
    return Observable<URL?>.create({ sender in
      let storage = Storage.storage()
      
      let storageRef = storage.reference()
      
      // Create a reference to the file you want to upload
      let riversRef = storageRef.child(saveAtPath)
      
      // Upload the file to the path "images/rivers.jpg"
      _ = riversRef.putFile(from: path, metadata: nil) { metadata, error in
        guard let _ = metadata else {
          sender.onError(error ?? ErrorMessage(message: "upload faild!!"))
          return
        }
        riversRef.downloadURL(completion: { (url, error) in
          if let error = error {
            sender.onError(error)
          } else {
            sender.onNext(url)
          }
          
        })
      }
      return Disposables.create()
    })
  }
  
  static func updatePoint() -> Observable<Bool> {
    return Observable<Bool>.create { sender in
      let point = UserModel.currentUser.point
      let userid = UserModel.currentUser.userID
      ref.child(userRef).child(userid).updateChildValues(["point": point + 20])
      sender.onNext(true)
    return Disposables.create()
    }
  }
}
