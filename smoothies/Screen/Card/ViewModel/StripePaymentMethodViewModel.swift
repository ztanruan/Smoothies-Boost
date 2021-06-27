//
//  StripePaymentMethodViewModel.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 4/20/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import RxSwift
import Stripe

protocol StripePaymentMethodViewModelType {
  
  var addPaymentSuccessSignal: PublishSubject<Void> { get }
  var addPaymentFailSignal: PublishSubject<String> { get }
  var listCards: [STPCard] { get }
  var cardDefault: STPCard? { get set }

  func getListPayment()
  func checkCardAdd(token: STPToken)
  func setCardDefault()
  
  var setCardDefaultSuccessSignal: PublishSubject<Void> { get }
  var setCardDefaultFailSignal: PublishSubject<String> { get }
  
  var updateCardDefaultSignal: PublishSubject<STPCard> { get }
}

class StripePaymentMethodViewModel: BaseViewModel, StripePaymentMethodViewModelType {

  var addPaymentSuccessSignal: PublishSubject = PublishSubject<Void>()
  var addPaymentFailSignal: PublishSubject = PublishSubject<String>()
  var listCards: [STPCard]
  var cardDefault: STPCard?
  
  var setCardDefaultSuccessSignal: PublishSubject<Void> =  PublishSubject<Void>()
  var setCardDefaultFailSignal: PublishSubject<String> =  PublishSubject<String>()

  var updateCardDefaultSignal: PublishSubject<STPCard> = PublishSubject<STPCard>()

  init(_ listCards: [STPCard], card: STPCard?) {

    self.listCards = listCards
    self.cardDefault = card
  }
  
  func getListPayment() {
    StripeApi.getListPaymentSource()
      .subscribe(onNext: { cards in
        self.listCards = cards
        self.addPaymentSuccessSignal.onNext(Void())
      }, onError: { error in
        print("Error")
      }, onCompleted: nil, onDisposed: nil)
    .disposed(by: disposebag)
  }
  
  func addNewPayment(token: String) {
    StripeApi.addNewCard(token: token)
      .subscribe(onNext: {[weak self] card in
        guard let self = self else { return }
        self.listCards.append(card)
        self.cardDefault = card
        self.addPaymentSuccessSignal.onNext(Void())

      }, onError: { error in
        self.addPaymentFailSignal.onNext((error as! ErrorMessage).message)
        
      }, onCompleted: nil, onDisposed: nil)
    .disposed(by: disposebag)
  }
  
  func setCardDefault() {
    guard let id = cardDefault?.allResponseFields["id"] as? String else {
      setCardDefaultFailSignal.onNext("Need to add card")
      return
    }
    
    StripeApi.setCardDefault(id: id)
      .subscribe(onNext: {[weak self] isAdd in
        if isAdd {
          self?.setCardDefaultSuccessSignal.onNext(Void())
        } else {
          self?.setCardDefaultFailSignal.onNext("Can't set card default")
        }
      }, onError: nil, onCompleted: nil, onDisposed: nil)
    .disposed(by: disposebag)
  }
  
  func checkCardAdd(token: STPToken) {

    StripeApi.checkCardIsExist(token: token)
      .subscribe(onNext: {[weak self] isExist in
        if isExist {
          self?.addPaymentFailSignal.onNext("Card is exist")
        } else {
          self?.addNewPayment(token: token.tokenId)
        }
      }, onError: nil, onCompleted: nil, onDisposed: nil)
    .disposed(by: disposebag)
  }
}
