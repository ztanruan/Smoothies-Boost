//
//  OrderApi.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 3/22/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//


// Class control the order system in the add
// Define and initialize the variable that we need for the order system
// Firebase template used in this file
// Import Firebase package and RxSwift

import FirebaseDatabase
import CodableFirebase
import RxSwift

class OrderApi {
  static let ref = Database.database().reference()
  static let dispose = DisposeBag()
  static let orderRef = "orders"
  
  static func createOrder(order: OrderModel) -> Observable<OrderModel> {
    return Observable<OrderModel>.create { sender in
      let customer = order.customerInfo
      let userid = UserModel.currentUser.userID
        
        
        // Initialize each object and variable

      let param: [String : Any] = [
        "user_id": userid,
        "order_id": order.orderID,
        "product_id": order.productID,
        "image": order.image,
        "name": order.name,
        "arrived": order.arrived,
        "serving": order.serving,
        "price": order.price,
        "unit": order.unit,
        "status": order.status,
        "customerInfo": [
          "address": customer.address,
          "apt": customer.apt ?? "",
          "state": customer.state,
          "city": customer.city,
          "postalCode": customer.postalCode,
          "phone": customer.phone
        ]
      ]
      ref.child(orderRef).child(order.orderID).setValue(param)
      ref.child(orderRef).child(order.orderID).observe(DataEventType.value, with: { snapshot in
        guard let value = snapshot.value else { return }
        do {
          let order = try FirebaseDecoder().decode(OrderModel.self, from: value)
          sender.onNext(order)
          
        } catch let error {
          sender.onError(ErrorMessage(message: error.localizedDescription))
        }
      })
      return Disposables.create()
    }
  }
  
  static func getListOrdersByUser() -> Observable<[OrderModel]> {
    return Observable<[OrderModel]>.create { sender in
      let userid = UserModel.currentUser.userID
      ref.child(orderRef).queryOrdered(byChild: "user_id").queryEqual(toValue: userid)
        .observe(.value, with: { snapshot in
          guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else { return }
          var orders: [OrderModel] = []
          snapshots.forEach({
            do {
              guard let value = $0.value else { return }
              let order = try FirebaseDecoder().decode(OrderModel.self, from: value)
              orders.append(order)
            } catch let error {
              sender.onError(ErrorMessage(message: error.localizedDescription))
            }
          })
          sender.onNext(orders)
        })
      return Disposables.create()
    }
  }
  
    
   // Update order status function and display it on the user interface
   // Update the order status in the firebase database
    
  static func updateStatusOrder(orderid: String, status: String) -> Observable<OrderModel> {
    return Observable<OrderModel>.create { sender in
      ref.child(orderRef).child(orderid).updateChildValues(["status" : status])
      ref.child(orderRef).child(orderid).queryLimited(toFirst: 20).observe(.value, with: { snapshot in
        guard let value = snapshot.value else { return }
        do {
          let order = try FirebaseDecoder().decode(OrderModel.self, from: value)
          sender.onNext(order)
          
        } catch let error {
          sender.onError(ErrorMessage(message: error.localizedDescription))
        }
      })
      return Disposables.create()
    }
  }
  
    
  // Get the user order list from the database and display it into the user view controller
    
  static func getListOrderByStatus(status: String) -> Observable<[OrderModel]> {
    return Observable<[OrderModel]>.create { sender in
      if status == "All" {
        getListAllOrders()
          .subscribe(onNext: { orders in
            sender.onNext(orders)
          }, onError: { error in
            sender.onError(error as! ErrorMessage)
          }, onCompleted: nil, onDisposed: nil)
        .disposed(by: dispose)
      } else {
        getListByStatus(status: status)
          .subscribe(onNext: { orders in
            sender.onNext(orders)
          }, onError: { error in
            sender.onError(error as! ErrorMessage)
          }, onCompleted: nil, onDisposed: nil)
        .disposed(by: dispose)
      }
      return Disposables.create()
    }
  }
  
    // Update the order status and store the details in the database firebase
    
  static func getListAllOrders() -> Observable<[OrderModel]> {
    return Observable<[OrderModel]>.create { sender in
      ref.child(orderRef)
        .observe(.value, with: { snapshot in
          guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else { return }
          var orders: [OrderModel] = []
          snapshots.forEach({
            do {
              guard let value = $0.value else { return }
              let order = try FirebaseDecoder().decode(OrderModel.self, from: value)
              orders.append(order)
            } catch let error {
              sender.onError(ErrorMessage(message: error.localizedDescription))
            }
          })
          sender.onNext(orders)
        })
      return Disposables.create()
    }
  }
  
    // Get the order status from the database and display it into the user view controller
    // Get the data from the firebase database
    
  static func getListByStatus(status: String) -> Observable<[OrderModel]> {
    return Observable<[OrderModel]>.create { sender in
      ref.child(orderRef).queryOrdered(byChild: "status").queryEqual(toValue: status)
        .observe(.value, with: { snapshot in
          guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else { return }
          var orders: [OrderModel] = []
          snapshots.forEach({
            do {
              guard let value = $0.value else { return }
              let order = try FirebaseDecoder().decode(OrderModel.self, from: value)
              orders.append(order)
            } catch let error {
              sender.onError(ErrorMessage(message: error.localizedDescription))
            }
          })
          sender.onNext(orders)
        })
      return Disposables.create()
    }
  }
  
    
    // Function allow manager to search from orders in the interface
    
  static func searchOrders(id: String) -> Observable<[OrderModel]> {
    return Observable<[OrderModel]>.create { sender in
      
      ref.child(orderRef).queryOrdered(byChild:  "order_id").queryStarting(atValue: id, childKey: "order_id").queryEnding(atValue: id + "\u{f8ff}", childKey: "order_id")
        .observeSingleEvent(of: .value, andPreviousSiblingKeyWith: { (snapshot, error) in
          guard let snapshots = snapshot.children.allObjects as? [DataSnapshot] else { return }
          var orders: [OrderModel] = []
          snapshots.forEach({
            do {
              guard let value = $0.value else { return }
              let order = try FirebaseDecoder().decode(OrderModel.self, from: value)
              orders.append(order)
            } catch let error {
              sender.onError(ErrorMessage(message: error.localizedDescription))
            }
          })
          sender.onNext(orders)
        })
      return Disposables.create()
    }
  }
}
