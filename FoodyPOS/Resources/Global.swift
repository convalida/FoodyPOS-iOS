//
//  Global.swift
//  FoodyPOS
//
//  Created by rajat on 26/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//
//  All global methods and functionality which are reusable in the application, are defined here

import Foundation
import UIKit

class Global:NSObject {
    
    /// Check if the device is iPad
    static var isIpad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    /// Display process indicator
    static func showHud(){
         DispatchQueue.main.async {
            ARSLineProgress.showWithPresentCompetionBlock {
                print("API Calling Start")
            }
        }
    }
    
    /// Hide process indicator
    static func hideHud() {
        DispatchQueue.main.async {
            ARSLineProgress.hideWithCompletionBlock {
                print("API Calling Stop")
            }
        }
    }
    
    /// Display Root View controller for application
    static func showRootView(withIdentifier identifier:String) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
        let navVC = UINavigationController.init(rootViewController: vc)
        navVC.isNavigationBarHidden = true
        appDelegate.window?.rootViewController = navVC
    }
    
    /// Clear all user default data
    static func flushUserDefaults() {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
    }

}
