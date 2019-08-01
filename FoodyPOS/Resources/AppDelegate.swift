//
//  AppDelegate.swift
//  FoodyPOS
//
//  Created by rajat on 26/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit
import UserNotifications

///Default class with pre defined life cycle methods of application.
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    /**
     Image that serves as visual background for your app's user interface and the object that dispatches events to your views.
     */
    var window: UIWindow?


/**
 Called when application is launched for first time. Set text color as theme. Call registerForPushNotifications method which registers to receive remote notifications via Apple Push Notification service. If isRemember and isLogin is true inUserManager class, show root view with identifier DashboardVC
 */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //set text field tint color
        UITextField.appearance().tintColor = UIColor.themeColor

        // Handling for push notifications
        registerForPushNotifications()
        // Show dashboard screen if user is already logged in
        if UserManager.isRemember && UserManager.isLogin {
            Global.showRootView(withIdentifier: StoryboardConstant.DashboardVC)
        }
        
        return true
    }
    
   /**
     Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background. If badge count on app icon is greater than 0, call callReadNotificationApi method with null parameter from Global class which will set the badge count to 0
     */
    func applicationWillEnterForeground(_ application: UIApplication) {
        var badgeCount = application.applicationIconBadgeNumber;
        if(badgeCount > 0){
            Global.callReadNotificationApi(nil)
        }
    }

}

extension AppDelegate {
    
    /**
     If available device version is iOS 10 or greater, request authorization to interact with the user when local and remote notifications are delivered to the user's device with ability to display alert, play sounds and update app's badge. If permission is granted, display in logs, else return. Register device to receive push notification. Retrieve the shared notification center object for your app.
     If available device version is less than 10, register your preferred options for notifying the user with ability to display alert, play sounds and update app's badge. Register device to receive push notification. Retrieve the shared notification center object for your app. UIUserNotificationSettings was deprecated in iOS 10 so alternative method is used
 */
    /// Ask users for push notification permission and get cloud key. Rajat ji, please confirm if this is also to be added in comments as this comment was already added
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
    
    /**
This method is called when user allows push notification. This method tells the delegate that the app successfully registered with Apple Push Notification service (APNs). From where deviceToken in method is passed, Rajat ji, please update that.
     Convert hexadecimal token to String. Rajat ji please check that.
     Return a new string by concatenating the elements of the sequence in token, adding the given separator between each element. Print token in logs. Set token value to UserManager token
     Call callLoginApi method from Global class. Rajat ji, please check this, as per comment added by you, this method is called when user allows push notification. So, as soon as user allowed push notification, login web service should be called, so it does not seem correct. Also, even if login web service is called, then UserManager class's User fields will be empty by default when user allows push notification. Rajat ji check this
     */
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
    /**
     Called when user deny push notification. Sent to the delegate when Apple Push Notification service cannot successfully complete the registration process. Print message in logs
 */
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // 1. Print out error if PNs registration not successful
        print("Failed to register for remote notifications with error: \(error)")
    }
    
    
    // Called when a notification is received
    /**
 Tells the app that a remote notification arrived that indicates there is data to be fetched. The system calls this method when your app is running in the foreground or background. UserInfo consists data (text) of notification. Rajat ji please check this. Get order id from notification. Call goToOrderDetailVC method which opens OrderDetailVC. As per comment added by you, this method is called when notification is receivedAccordingly, this method will open OrderDetailVC. Rajat ji please check this.
     Call callReadNotificationApi method from Global class which sets the badge on app icon to 0
     */
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
    /**
 If navVC is rootViewController, return. Rajat ji please check this as if notification is received when visible view controller is rootViewController (LoginVC as per my understanding), then return.
     If currently visible view controller is OrderDetailVC, get orderNo. from body, Rajat ji please check this and post notification to OrderDetailVC with order no. from notification body.
     After that, Rajat ji please add comment. Pass order no. to view controller. Set badge no. on app icon to 0.
     Rajat ji ideally, update comment to this whole method if possible
     */
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
        ///Get version no. of bundle. Where this is used Rajat ji please update this
        get {
            return Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String
        }
    }
    ///Rajat ji update this, and where it is used
    class var version: String? {
        get {
            return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        }
    }
    ///Used in device type parameter for login api. It returns null in case of iOS. Rajat ji please check this
    class var appId: String? {
        get {
        //    return Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
            return ""
        }
    }
    }

extension AppDelegate:UNUserNotificationCenterDelegate {
    /**
 For devices above iOS 10, ask the delegate how to handle a notification that arrived while the app was running in the foreground. Display the alert using the content provided by the notification. Play the sound associated with the notification. Apply the notification's badge value to the app’s icon.
     When this method is called, Rajat ji please update this
     */
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound,.badge])
    }
}
