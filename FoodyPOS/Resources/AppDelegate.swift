//
//  AppDelegate.swift
//  FoodyPOS
//
//  Created by rajat on 26/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //set text field tint color
        UITextField.appearance().tintColor = UIColor.themeColor

        // Handling for push notifications
        registerForPushNotifications()
        // Show dashboard screen if user is already logged in
        if UserManager.isRemember && UserManager.isLogin {
            Global.showRootView(withIdentifier: StoryboardConstant.DashboardVC)
        }
        
        Global.callReadNotificationApi(nil)
        
        return true
    }

}

extension AppDelegate {
    
    /// Ask users for push notification permission and get cloud key
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                print("Permission granted: \(granted)")
                // 1. Check if permission granted
                guard granted else { return }
                // 2. Attempt registration for remote notifications on the main thread
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
            UNUserNotificationCenter.current().delegate = self
        } else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    // called when user allows push notification
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 1. Convert device token to string
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        // 2. Print device token to use for PNs payloads
        print("Device Token: \(token)")
        UserManager.token = token
        if token.trim() != "" {
            DispatchQueue.global().async {
                Global.callLoginApi()
            }
        }
    }
    
    
    // called when user deny push notification
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // 1. Print out error if PNs registration not successful
        print("Failed to register for remote notifications with error: \(error)")
    }
    
    
    // Called when a notification is received
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        if let orderId = userInfo["order_id"] as? String {
            goToDetailVC(body: orderId)
            Global.callReadNotificationApi(orderId)
            application.applicationIconBadgeNumber = 0
            completionHandler(.newData)
        }
    }
}

extension AppDelegate {
    func goToDetailVC(body:String) {
        guard let navVC = self.window?.rootViewController as? UINavigationController else {
            return
        }
        if navVC.visibleViewController is OrderDetailVC {
            let info = ["orderNo":body]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kOrderDetailNotification), object: nil, userInfo: info)
        } else {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: StoryboardConstant.OrderDetailVC) as! OrderDetailVC
            vc.orderNo = body
            UIApplication.shared.applicationIconBadgeNumber = 0;
            navVC.pushViewController(vc, animated: true)
        }
    }
}

extension UIApplication {
    class var build: String? {
        get {
            return Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String
        }
    }
    
    class var version: String? {
        get {
            return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        }
    }
    
    class var appId: String? {
        get {
        //    return Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
            return ""
        }
    }
    }

extension AppDelegate:UNUserNotificationCenterDelegate {
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound,.badge])
    }
}
