//
//  AboutUs.swift
//  smoothies
//
//  Created by zhen xin  tan ruan on 4/29/19.
//  Copyright © 2019 zhen xin  tan ruan. All rights reserved.
//


// Class for the about us view controller
// Define the back buttom for user to reeturn to the previous page (View Controller)
// This class will handle the back botton on the about us view controller

import Foundation
import UIKit

class AboutUs: UIViewController {

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }

@IBAction func handleBack(_sender: Any)
    
{
    navigationController?.popViewController(animated: true)
    }


}
