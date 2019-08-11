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

///Class with common methods that are used throughout the project.
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
    
    /**
     Display root view controller for application. Hide navigation bar from navigation controller. Set window declared in AppDelegate to root view controller. Navigation bar is explicitly set in all required controllers. Navbar is not shown on some controllers like loginVC.
     */
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

    /**
     Call login api. If email id and password in UserManager is empty, return. Pass parameters email id, password, device id from  UserManager class, build version and app id from AppDelegate to APIClient. If api hit is successful and result code is 1, call saveUserDataIntoDefaults in UserManager class.
     In case of error, print error in logs. This is used in Global.swift to save the token.
     */
    static func callLoginApi() {
        //Validate all the field
        if UserManager.email == nil && UserManager.password == nil {
            return
        }
        let parameterDic = ["email":UserManager.email ?? "",
                            "password":UserManager.password ?? "",
                            "deviceId":UserManager.token ?? "",
                            "buildversion":UIApplication.version ?? "",
                            "DeviceType":UIApplication.appId ?? ""] as [String:Any]
        
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
    
    /**
 Call read notification api. Take parameter device id UserManager class token, if order no. is not null, then take order no. else take order no. as empty and pass parameters to ApiClient readNotification method. If api hit is successful and result is 1, set badge no. on app icon 0. In case of failure, print error message in logs.
     */
    static func callReadNotificationApi(_ orderNo:String?) {
        //Validate all the field
        var parameterDic = [
                            "deviceid":UserManager.token ?? ""
                            ] as [String:Any]
        if(orderNo != nil){
            parameterDic["orderno"] = orderNo!
        } else {
            parameterDic["orderno"] = ""
        }
        
        //Call Read Notification API
        APIClient.readNotification(paramters: parameterDic) { (result) in
            print(result)
            switch result {
            case .success(let user):
                print("Read Notification API Called")
                if let result = user.result {
                    if result == "1" {
                        UIApplication.shared.applicationIconBadgeNumber = 0
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

///For layout constraint
class DeviceLayoutConstraint:NSLayoutConstraint {
    
    ///Set the value according to iPhoneX
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
    
        ///This is a common method and it depends on the object of the class. FirstItem and second Item are the children of NSLayoutConstraint
    open func layoutIfNeeded() {// inflate 2 items at a time
        self.firstItem?.layoutIfNeeded()
        self.secondItem?.layoutIfNeeded()
    }
}
