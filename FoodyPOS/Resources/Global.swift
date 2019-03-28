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

    static func callLoginApi() {
        //Validate all the field
        let parameterDic = ["email":UserManager.email ?? "",
                            "password":UserManager.password ?? "",
                            "deviceId":UserManager.token ?? "",
                            "buildversion":UIApplication.version ?? "",
                            "AppId":UIApplication.appId ?? ""] as [String:Any]
        
        //Call Login API
        APIClient.login(paramters: parameterDic) { (result) in
            switch result {
            case .success(let user):
                if let result = user.result {
                    if result == "1" {
                        UserManager.saveUserDataIntoDefaults(user: user)
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func callReadNotificationApi(_ orderNo:String) {
        //Validate all the field
        let parameterDic = [
                            "deviceid":UserManager.token ?? "",
                            "orderno":orderNo,
                            ] as [String:Any]
        
        //Call Read Notification API
        APIClient.readNotification(paramters: parameterDic) { (result) in
            switch result {
            case .success(let user):
                if let result = user.result {
                    if result == "1" {
                        //UserManager.saveUserDataIntoDefaults(user: user)
                        UIApplication.shared.applicationIconBadgeNumber = 0
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

class DeviceLayoutConstraint:NSLayoutConstraint {
    
    @IBInspectable var isIphoneXValue:CGFloat = 0.0 {
        didSet {
            if UIDevice().userInterfaceIdiom == .phone {
                if UIScreen.main.nativeBounds.height == 2436 || UIScreen.main.nativeBounds.height == 2688 || UIScreen.main.nativeBounds.height == 1792 {
                    self.constant = isIphoneXValue
                    layoutIfNeeded()
                }
            }
        }
    }
    
    open func layoutIfNeeded() {
        self.firstItem?.layoutIfNeeded()
        self.secondItem?.layoutIfNeeded()
    }
}
