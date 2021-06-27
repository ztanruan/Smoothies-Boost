//
//  testStripeVCViewController.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 3/16/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import Stripe
import FirebaseFunctions
import RxSwift
import FirebaseDatabase

class testStripeVCViewController: BaseViewController, STPPaymentContextDelegate {
  private let customerContext = MockCustomerContext()
  private let paymentContext: STPPaymentContext
  var customer = MockCustomer()
  
  var products = [ProductModel]()
  required init?(coder aDecoder: NSCoder) {
    
    paymentContext = STPPaymentContext(customerContext: customerContext)
    
    super.init(coder: aDecoder)
    
    paymentContext.delegate = self
    paymentContext.hostViewController = self
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //    AuthenApi.signin(email: "traen166@gmail.com", password: "12345678")
    //      .subscribe(onNext: { user in
    //        print("successs")
    //      }, onError: nil, onCompleted: nil, onDisposed: nil)
    //      .disposed(by: disposeBag)
    //    generateProducts()
    //    getListProducts()
    //    createOrder()
    
//    getListPaymentSources()
    generateProducts()
  }
  
  @IBAction func add(_ sneder: Any) {
    
    
    //    presentPaymentMethodsViewController()
    //addcard
    
        let card = STPAddCardViewController()
        card.delegate = self
        let navi = UINavigationController(rootViewController: card)
        present(navi, animated: true, completion: nil)
//    self.customerContext.customer = customer
//    
//    let config = STPPaymentConfiguration()
//    config.additionalPaymentMethods = .all
//    config.requiredBillingAddressFields = .none
//    config.appleMerchantIdentifier = "dummy-merchant-id"
//    let viewController = STPPaymentMethodsViewController(configuration: config, theme: STPTheme.default(), customerContext: self.customerContext, delegate: self)
//    let navigationController = UINavigationController(rootViewController: viewController)
//    navigationController.navigationBar.stp_theme = STPTheme.default()
//    present(navigationController, animated: true, completion: nil)
    
    //    let vc = STPPaymentMethodsViewController()
    //    let navi = UINavigationController(rootViewController: vc)
    //    present(navi, animated: true, completion: nil)
  }
  
  private func presentPaymentMethodsViewController() {
    
    paymentContext.presentPaymentMethodsViewController()
  }
  
  func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
    if let customerKeyError = error as? StripeApi.CustomerKeyError {
      switch customerKeyError {
      case .missingBaseURL:
        // Fail silently until base url string is set
        print("[ERROR]: Please assign a value to `MainAPIClient.shared.baseURLString` before continuing. See `AppDelegate.swift`.")
      case .invalidResponse:
        // Use customer key specific error message
        print("[ERROR]: Missing or malformed response when attempting to `MainAPIClient.shared.createCustomerKey`. Please check internet connection and backend response formatting.");
        
        
      }
    }
    else {
      // Use generic error message
      print("[ERROR]: Unrecognized error while loading payment context: \(error)");
      
    }
  }
  
  func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
    // Reload related components
    //    reloadPaymentButtonContent()
    //    reloadRequestRideButton()
  }
  
  func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
    // Create charge using payment result
    //    let source = paymentResult.source.stripeID
    
    //    StripeApi.shared.requestRide(source: source, amount: price, currency: "usd") { [weak self] (ride, error) in
    //      guard let strongSelf = self else {
    //        // View controller was deallocated
    //        return
    //      }
    //
    //      guard error == nil else {
    //        // Error while requesting ride
    //        completion(error)
    //        return
    //      }
    //
    //      // Save ride info to display after payment finished
    //      strongSelf.rideRequestState = .active(ride!)
    completion(nil)
    //    }
  }
  
  func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
    switch status {
    case .success:
      // Animate active ride
      //      animateActiveRide()
      print("Successssss")
    case .error:
      // Present error to user
      if let requestRideError = error as? StripeApi.RequestRideError {
        switch requestRideError {
        case .missingBaseURL:
          // Fail silently until base url string is set
          print("[ERROR]: Please assign a value to `MainAPIClient.shared.baseURLString` before continuing. See `AppDelegate.swift`.")
        case .invalidResponse:
          // Missing response from backend
          print("[ERROR]: Missing or malformed response when attempting to `MainAPIClient.shared.requestRide`. Please check internet connection and backend response formatting.");
          //          present(UIAlertController(message: "Could not request ride"), animated: true)
        }
      }
      else {
        // Use generic error message
        print("[ERROR]: Unrecognized error while finishing payment: \(String(describing: error))");
        //        present(UIAlertController(message: "Could not request ride"), animated: true)
      }
      
      // Reset ride request state
    //      rideRequestState = .none
    case .userCancellation:
      break
    }
  }
}

extension testStripeVCViewController: STPAddCardViewControllerDelegate {
  func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
    
  }
  
  func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
    print("token \(token.allResponseFields)")
    
//    Database.database().reference().child("stripe_customers").child(""LAntK09HO8QMyHtHZDK5ax8k2Az2"").child("sources").childByAutoId().child("token").setValue(token.tokenId)
  }
  
}

// MARK: Test authen
extension testStripeVCViewController {
  func testAuthen() {
//    AuthenApi.signup(email: "traenl66@gmail.com", username: "lantran", password: "12345678").subscribe(onNext: { user in
//      print("dhdhdhdhdh")
//    }, onError: nil, onCompleted: nil, onDisposed: nil)
//      .disposed(by: disposeBag)
//    
//    AuthenApi.signin(email: "traen166@gmail.com", password: "12345678")
//      .subscribe(onNext: { user in
//        print("successs")
//      }, onError: nil, onCompleted: nil, onDisposed: nil)
//      .disposed(by: disposeBag)
  }
}

// MARK: Test create products

extension testStripeVCViewController {
  
  func generateProducts() {
    
    var ingridients = [[String : Any]]()
    var in1 = [String : Any]()
    in1["name"] = "2 cucumber"
    in1["price"] = 2
    in1["unit"] = "USD"
    
    var in2 = [String : Any]()
    in2["name"] = "1/2 letture"
    in2["price"] = 4
    in2["unit"] = "USD"
    
    var in3 = [String : Any]()
    in3["name"] = "1 apple"
    in3["price"] = 6
    in3["unit"] = "USD"
    
    var in4 = [String : Any]()
    in4["name"] = "1/2 kiwi"
    in4["price"] = 8
    in4["unit"] = "USD"
    
    ingridients = [in1, in2, in3, in4]
    
    var garnish = [[String : Any]]()
    
    var ga1 = [String : Any]()
    ga1["name"] = "slice orange"
    ga1["price"] = 6
    ga1["unit"] = "USD"
    
    garnish = [ga1]
    
    var drinkware = [[String : Any]]()
    
    var dr1 = [String : Any]()
    dr1["name"] = "glass"
    dr1["price"] = 10
    dr1["unit"] = "USD"
    
    var dr2 = [String : Any]()
    dr2["name"] = "straw"
    dr2["price"] = 12
    dr2["unit"] = "USD"
    
    drinkware = [dr1, dr2]
    
    let id = randomString(length: 30)
    let param = [
      "product_id": id,
      "name": "Green",
      "image": "https://firebasestorage.googleapis.com/v0/b/smoothies-d6911.appspot.com/o/a48bca22785d142bab2db7fb7b905a85.png?alt=media&token=2f1619bc-6cac-459a-a06f-e3e9e6c21288",
      "cate": "smoothies",
      "rating": 0,
      "time": 30,
      "ingredients": ingridients,
      "served": "poured over ice",
      "standardGarnish": garnish,
      "drinkware": drinkware,
      "preparation": "Start your smoothie with two mugfuls of a liquid base. This can be milk, or a dairy-free alternative such as soya or almond milk, natural or flavoured yogurt, fruit juice, or for a tropical flavoured smoothie, low-fat coconut milk or coconut water. It's important to add the liquid to your blender before adding the fruit, as this will prevent the blade from getting damaged",
      "servings": [10, 20, 30, 40, 50],
      "userLikes": []
      ] as [String : Any]
    print("paramparm \(param)")
    Database.database().reference().child("products").child(id).setValue(param)
  }
  
  func randomString(length: Int) -> String {
    let charactersString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let charactersArray : [Character] = Array(charactersString)
    
    var string = ""
    for _ in 0..<length {
      string.append(charactersArray[Int(arc4random()) % charactersArray.count])
    }
    
    return string
  }
}

extension testStripeVCViewController: STPPaymentMethodsViewControllerDelegate {
  func internalViewControllerDidCreateSource(_ source: STPSourceProtocol, completion: @escaping STPErrorBlock) {
    print("aaaa")
  }
  
  func paymentMethodsViewController(_ paymentMethodsViewController: STPPaymentMethodsViewController, didSelect paymentMethod: STPPaymentMethod) {
    print("aaaaaaa")
  }
  
  func paymentMethodsViewControllerDidCancel(_ paymentMethodsViewController: STPPaymentMethodsViewController) {
    print("cancel")
  }
  
  func paymentMethodsViewController(_ paymentMethodsViewController: STPPaymentMethodsViewController, didFailToLoadWithError error: Error) {
    print("fail")
  }
  
  func paymentMethodsViewControllerDidFinish(_ paymentMethodsViewController: STPPaymentMethodsViewController) {
    print("finish")
  }
}

//MARK: Get products

extension testStripeVCViewController {
  
  func getListProducts() {
    ProductApi.getListProducts()
      .subscribe(onNext: { products in
        print("success")
        self.products = products
      }, onError: { error in
        print("errorror")
      }, onCompleted: nil, onDisposed: nil)
      .disposed(by: disposeBag)
  }
  
  func likeProduct(product: ProductModel) {
    ProductApi.likeProduct(product: product)
      .subscribe(onNext: { isLiked in
        print("isliked \(isLiked)")
      }, onError: { error in
        print("error")
      }, onCompleted: nil, onDisposed: nil)
      .disposed(by: disposeBag)
  }
}

//MARK: Get city state
extension testStripeVCViewController {
  
  //  func initStateData() {
  //    let id = randomString(length: 30)
  //    ProductApi.initStatesData(id: id)
  //  }
  
  func getListState() {
    ProductApi.getListStates()
      .subscribe(onNext: { states in
        print("states \(states)")
      }, onError: { error in
        print("Error")
      }, onCompleted: nil, onDisposed: nil)
      .disposed(by: disposeBag)
  }
}

//MARK: Order
extension testStripeVCViewController {
  
  func createOrder() {
    let customer = CustomerInfoModel()
    customer.initCustomer(address: "31 su van hanh", apt: "34 oer", state: "New York", city: "New York", postalCode: "30000", phone: "0392939290")
    let order = OrderModel()
    let id = randomString(length: 30)
    order.initCustomer(orderID: id, productID: "iOQfD8sGqVT7st09oz1Yb9zM273pKt", image: "https://firebasestorage.googleapis.com/v0/b/smoothies-d6911.appspot.com/o/6a2a85917cf7118b9f1cdb9b30b3d687.png?alt=media&token=15712f13-7b92-4ff7-8a06-098f93e4260b", name: "Strawberries", arrived: "2pm - 2:30pm", serving: 20, price: 50, unit: "USD", status: "Processed", customerInfo: customer, userID: "465dufdyg57fdyt7y57")
    
    OrderApi.createOrder(order: order)
      .subscribe(onNext: { orderUpdated in
        print("successs")
      }, onError: { error in
        print("Error")
      }, onCompleted: nil, onDisposed: nil)
      .disposed(by: disposeBag)
  }
}


//Stripe

extension testStripeVCViewController {
  
  func getListPaymentSources() {
    StripeApi.getListPaymentSource()
      .subscribe(onNext: { cards in
        print("Success")
        self.customer.sources = cards
      }, onError: { error in
        print("Error")
      }, onCompleted: nil, onDisposed: nil)
      .disposed(by: disposeBag)
  }
}

