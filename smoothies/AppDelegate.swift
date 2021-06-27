//
//  AppDelegate.swift
//  smoothie
//
//  Created by zhen xin  tan ruan on 3/13/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//

import UIKit
import Stripe
import Firebase
import IQKeyboardManager
import Messages
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    IQKeyboardManager.shared().isEnabled = true
    IQKeyboardManager.shared().isEnableAutoToolbar = false
    IQKeyboardManager.shared().shouldResignOnTouchOutside = true
    
    FirebaseApp.configure()
    application.registerForRemoteNotifications()
    requestNotificationAuthorization(application: application)
    Messaging.messaging().delegate = self

    if let userInfo = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] {
      print("[RemoteNotification] applicationState: didFinishLaunchingWithOptions for iOS9: \(userInfo)")
    }
    
    STPPaymentConfiguration.shared().publishableKey = "pk_test_xBExxvHU27Dfh0QeDrRBd16T00xNONSZ57"
    
    window = UIWindow(frame: UIScreen.main.bounds)
    //window?.tintColor = .white
//
//    if let key: Bool = UserDefaults.standard.bool(forKey: "isShowFlash"), key == true {
//      let rootVC =  UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
//      let nav = UINavigationController(rootViewController: rootVC)
//      window?.rootViewController = nav
//
//    } else {
      let rootVC =  UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SplashViewController")
      window?.rootViewController = rootVC
    //}

    window?.makeKeyAndVisible()
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
  }

  func applicationWillTerminate(_ application: UIApplication) {
  }
}

extension AppDelegate {
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Auth.auth().setAPNSToken(deviceToken, type: AuthAPNSTokenType.sandbox)
  }
  
  func changeRootVC(vc: UIViewController?, animation: Bool = true) {
    guard let window = window else {
      return
    }
    if !animation {
      window.rootViewController = vc!
      window.makeKeyAndVisible()
    } else {
      UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
        window.rootViewController = vc!
        window.makeKeyAndVisible()
      }, completion: nil )
    }
  }
  
  func requestNotificationAuthorization(application: UIApplication) {
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_,_ in })
    } else {
      let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }
  }
}

// MARK: - MessagingDelegate
extension AppDelegate : MessagingDelegate {
  
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
    print("Firebase registration token: \(fcmToken)")
    Constants.FirebaseConstant.token = fcmToken
  }
  
  
  
  // iOS9, called when presenting notification in foreground
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
    if UIApplication.shared.applicationState == .active {
      //TODO: Handle foreground notification
    } else {
      //TODO: Handle background notification
    }
  }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
  // iOS10+, called when presenting notification in foreground
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    
      completionHandler([.alert, .badge, .sound])
    
  }
  
  // iOS10+, called when received response (default open, dismiss or custom action) for a notification
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
  }
}
