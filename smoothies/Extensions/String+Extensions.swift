//
//  String+Extensions.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 4/27/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//




 // Define the variable that we are going to use to create the user order information
 // Initialize the variables and time
 // Use this class to set the delivery interval time for each order
 // The app will stop  accepting orders after 9:30 pm, it will not allow user to place orders


import UIKit

// Extension for the order view controller

extension String {
  
  var isBlank: Bool {
    get {
      let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
      return trimmed.isEmpty
    }
  }
  
  func isEmailValid() -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: self)
  }
  
  func isPhoneNumberValid(number: Int?) -> Bool {
    let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
    let inputString = self.components(separatedBy: charcterSet)
    let filtered = inputString.joined(separator: "")
    
    if let num = number, filtered.count != num {
      return false
    }
    return  self == filtered
  }
  
  func isPasswordValid() -> Bool {
    return self.count > 6
  }
  
    
   // Create user order ID using random characters
   // Define and Initialize the variables
   // Generate the random order IDs
    
  func randomIdString(length: Int = 30) -> String {
    let charactersString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let charactersArray : [Character] = Array(charactersString)
    
    var string = ""
    for _ in 0..<length {
      string.append(charactersArray[Int(arc4random()) % charactersArray.count])
    }
    
    return string
  }
  
  func getTimeDeliver() -> String? {
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    let timeString = dateFormatter.string(from: date)
    let timeComponent = timeString.components(separatedBy: ":")
    let hour: Int = Int(timeComponent.first ?? "0") ?? 0
    let minute: Int = Int(timeComponent.last ?? "0") ?? 0
    
    let currentTime = hour*60 + minute
    let openTime = 9*60
    let closeTime = 23*60
    
    if currentTime < openTime || currentTime > closeTime {
      return nil
    }
    
    let minTimeOrder = currentTime + 30
    let minHour = minTimeOrder/60
    let minMinute = minTimeOrder%60
    
    let maxTimeOrder = currentTime + 90
    let maxHour = maxTimeOrder/60
    let maxMinute = maxTimeOrder%60
    
    return String(minHour) + ":" +  String(minMinute) + " to " + String(maxHour) + ":" + String(maxMinute)
  }
}

