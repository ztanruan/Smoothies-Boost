//
//  ProductApi.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 3/24/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//



// Template from online from Firebase Library
// Stripe Library template

import FirebaseDatabase
import CodableFirebase
import RxSwift

class ProductApi {
  
  static let ref = Database.database().reference()
  static let dispose = DisposeBag()
  static let productRef = "products"
  static let statesRef = "states"
  
  static func getListProducts() -> Observable<[ProductModel]> {
    return Observable<[ProductModel]>.create { sender in
      
      ref.child(productRef).observe(.value, with: { snapshot in
        guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else { return }
        var products: [ProductModel] = []
        snapshots.forEach({
          do {
            guard let value = $0.value else { return }
            let product = try FirebaseDecoder().decode(ProductModel.self, from: value)
            products.append(product)
          } catch let error {
            sender.onError(ErrorMessage(message: error.localizedDescription))
          }
        })
        sender.onNext(products)
      })
      
      return Disposables.create()
    }
  }
  
  static func likeProduct(product: ProductModel) -> Observable<Bool> {
    return Observable<Bool>.create { sender in
      let userid = UserModel.currentUser.userID
      if product.userLikes == nil {
        product.userLikes = []
      }
      
      if let index = product.userLikes?.firstIndex(where: {$0 == userid }) {
        product.userLikes?.remove(at: index)
      } else {
        product.userLikes?.append(userid)
      }
      
      ref.child(productRef).child(product.id).updateChildValues(["userLikes" : product.userLikes ?? []])
      ref.child(productRef).child(product.id).observe(DataEventType.value, with: { snapshot in
        guard let value = snapshot.value else { return }
        do {
          let product = try FirebaseDecoder().decode(ProductModel.self, from: value)
          let userLikes = product.userLikes ?? []
          sender.onNext(userLikes.contains(userid))
          
        } catch let error {
          sender.onError(ErrorMessage(message: error.localizedDescription))
        }
      })
      return Disposables.create()
    }
  }
}

//State
extension ProductApi {
  
  static func initStatesData(id: String) {
    let param: [String : Any] = [
      "state_id": id,
      "statename": "Washington",
      "cities": [ "Seattle", "Spokane", "Tacoma", "Vancouver", "Bellevue"]
    ]
    
    ref.child(statesRef).child(id).updateChildValues(param)
  }
  
  static func getListStates() -> Observable<[StateModel]> {
    return Observable<[StateModel]>.create { sender in
      
      ref.child(statesRef).observe(.value, with: { snapshot in
        guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else { return }
        var states: [StateModel] = []
        snapshots.forEach({
          do {
            guard let value = $0.value else { return }
            let state = try FirebaseDecoder().decode(StateModel.self, from: value)
            states.append(state)
          } catch let error {
            sender.onError(ErrorMessage(message: error.localizedDescription))
          }
        })
        sender.onNext(states)
      })
      
      return Disposables.create()
    }
  }
}
