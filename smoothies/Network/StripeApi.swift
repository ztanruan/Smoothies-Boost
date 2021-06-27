//
//  StripeApi.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 3/20/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

// Template from online from Stripe SKD Library
// Stripe Library template

import Stripe
import RxSwift
import FirebaseDatabase
import CodableFirebase

class StripeApi: NSObject {
  
  static let shared = StripeApi()
  
  var baseURLString = "https://smoothies-d6911.firebaseapp.com/"
  
  static let ref = Database.database().reference()
  static let dispose = DisposeBag()
  static let stripeRef = "stripe_customers"
  // MARK: Rocket Rides
  
  enum RequestRideError: Error {
    case missingBaseURL
    case invalidResponse
  }
  
  //  func requestRide(source: String, amount: Int, currency: String, completion: @escaping (Ride?, RequestRideError?) -> Void) {
  //    let endpoint = "/api/rides"
  //
  //    guard
  //      !baseURLString.isEmpty,
  //      let baseURL = URL(string: baseURLString),
  //      let url = URL(string: endpoint, relativeTo: baseURL) else {
  //        completion(nil, .missingBaseURL)
  //        return
  //    }
  //
  //    // Important: For this demo, we're trusting the `amount` and `currency` coming from the client request.
  //    // A real application should absolutely have the `amount` and `currency` securely computed on the backend
  //    // to make sure the user can't change the payment amount from their web browser or client-side environment.
  //    let parameters: [String: Any] = [
  //      "source": source,
  //      "amount": amount,
  //      "currency": currency,
  //      ]
  //
  //    Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
  //      guard let json = response.result.value as? [String: Any] else {
  //        completion(nil, .invalidResponse)
  //        return
  //      }
  //
  //      guard let pilotName = json["pilot_name"] as? String,
  //        let pilotVehicle = json["pilot_vehicle"] as? String,
  //        let pilotLicense = json["pilot_license"] as? String else {
  //          completion(nil, .invalidResponse)
  //          return
  //      }
  //
  //      completion(Ride(pilotName: pilotName, pilotVehicle: pilotVehicle, pilotLicense: pilotLicense), nil)
  //    }
  
  // MARK: STPEphemeralKeyProvider
  
  enum CustomerKeyError: Error {
    case missingBaseURL
    case invalidResponse
  }
  
//  func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
//    let endpoint = "https://smoothies-d6911.firebaseapp.com/ephemeral_keys"
//
//    guard
//      !baseURLString.isEmpty,
//      let baseURL = URL(string: endpoint) else {
//        completion(nil, CustomerKeyError.missingBaseURL)
//        return
//    }
//
//    let parameters: [String: Any] = ["api_version": apiVersion]
//
//    Alamofire.request(baseURL, method: .post, parameters: parameters).responseJSON { (response) in
//      guard let json = response.result.value as? [AnyHashable: Any] else {
//        completion(nil, CustomerKeyError.invalidResponse)
//        return
//      }
//
//      completion(json, nil)
//    }
//  }
  
  static func getListPaymentSource() -> Observable<[STPCard]> {
    return Observable<[STPCard]>.create { sender in
      let userid = UserModel.currentUser.userID
      ref.child(stripeRef).child(userid).child("sources")
        .observeSingleEvent(of: DataEventType.value, with: { snapshot in
          guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else { return }
          var cards: [STPCard] = []
          snapshots.forEach({
            if let card = STPCard.decodedObject(fromAPIResponse: $0.value as? [AnyHashable : Any]) {
              cards.append(card)
            }
          })
          sender.onNext(cards)
        })
      return Disposables.create()
    }
  }
  
  static func getPaymentDefaultId() -> Observable<String> {
    return Observable<String>.create { sender in
      let userid = UserModel.currentUser.userID
      ref.child(stripeRef).child(userid)
        .child("default")
        .observe(.value, with: { snapshot in
          guard let value = snapshot.value else { return }
          print("valueeee \(value)")
          if ((value as? NSNull) != nil) {
            sender.onNext("")
          } else {
            sender.onNext(value as! String)
          }
        })
      return Disposables.create()
    }
  }
}

extension StripeApi {
  
  static func addNewCard(token: String) -> Observable<STPCard> {
    return Observable<STPCard>.create { sender in
      let userid = UserModel.currentUser.userID

      let id = "".randomIdString()
      ref.child(stripeRef)
        .child(userid)
        .child("sources")
        .child(id)
        .child("token")
        .setValue(token, withCompletionBlock: { (error, dataRef) in
          if let message = error {
            sender.onError(ErrorMessage(message: message.localizedDescription))
          }
        })
      
      ref.child(stripeRef)
        .child(userid)
        .child("sources")
        .observeSingleEvent(of: DataEventType.childChanged, with: { snapshot in
          guard let value = snapshot.value as? [AnyHashable : Any] else { return }
          if let card = STPCard.decodedObject(fromAPIResponse: value) {
            sender.onNext(card)
          } else {
            
          }
        })
      return Disposables.create()
    }
  }
  
  static func setCardDefault(id: String) -> Observable<Bool> {
    return Observable<Bool>.create { sender in
      let userid = UserModel.currentUser.userID
      ref.child(stripeRef)
        .child(userid)
        .child("default")
        .setValue(id, withCompletionBlock: { (error, newRef) in
          sender.onNext(error == nil ? true : false)
        })
      return Disposables.create()
    }
  }
  
  static func checkCardIsExist(token: STPToken) -> Observable<Bool> {
    return Observable<Bool>.create { sender in
      let userid = UserModel.currentUser.userID

      let last4 = token.card?.last4 ?? ""
      let month = token.card?.expMonth ?? 0
      let year = token.card?.expYear ?? 0

      ref.child(stripeRef)
        .child(userid)
        .child("sources")
        .queryOrdered(byChild: "last4")
        .queryEqual(toValue: last4)
        .observe(DataEventType.value, with: { snapshot in
          guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else {
            sender.onNext(false)
            return
          }
          var cards: [STPCard] = []
          snapshots.forEach({
            guard let value = $0.value as? [AnyHashable : Any] else { return }
            if let card = STPCard.decodedObject(fromAPIResponse: value) {
              cards.append(card)
            }
          })
          let filter = cards.filter({$0.expMonth == month && $0.expYear == year})
          sender.onNext(filter.count == 0 ? false : true)
        })
      return Disposables.create()
    }
  }
  
  static func charge(card: STPCard, amount: Int) -> Observable<Bool> {
    return Observable<Bool>.create { sender in
      let userid = UserModel.currentUser.userID

      ref.child(stripeRef)
        .child(userid)
        .child("charges")
        .childByAutoId()
        .setValue(["amount" : amount, "source" : card.stripeID, "currency" : "usd"], withCompletionBlock: { (error, refResult) in
          if let message = error {
            sender.onError(ErrorMessage(message: message.localizedDescription))
          } else {
            sender.onNext(true)
          }
        })
      return Disposables.create()
    }
  }
}
