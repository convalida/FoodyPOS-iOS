//
//  UIViewController.swift
//  SwiftAmplifier
//
//  Created by Rajat Jain on 01/08/17.
//  Copyright © 2017 rajatjain4061. All rights reserved.
//  Fork this repo on Github: https://github.com/rajatjain4061/SwiftAmplifier
//

import Foundation
import UIKit
import Toaster

extension UIViewController {
    
    func showAlert(title:String,message:String,actions:[UIAlertAction]? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if actions != nil {
            for action in actions! {
                alert.addAction(action)
            }
        } else {
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(defaultAction)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func showToast(_ text:String) {
        if let currentToast = ToastCenter.default.currentToast {
            currentToast.cancel()
        }
        Toast(text: text).show()
    }
    
    func showToast(text:String,delay:TimeInterval,duration:TimeInterval) {
        if let currentToast = ToastCenter.default.currentToast {
            currentToast.cancel()
        }
        Toast(text: text, delay: delay, duration: duration).show()
    }
    
}
