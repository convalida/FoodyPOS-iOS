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
     Ask users for push notification permission and get cloud key.
     If available device version is iOS 10 or greater, request authorization to interact with the user when local and remote notifications are delivered to the user's device with ability to display alert, play sounds and update app's badge. If permission is granted, display in logs, else return. Register device to receive push notification. Retrieve the shared notification center object for your app.
     If available device version is less than 10, register your preferred options for notifying the user with ability to display alert, play sounds and update app's badge. Register device to receive push notification. Retrieve the shared notification center object for your app. UIUserNotificationSettings was deprecated in iOS 10 so alternative method is used
 */
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
    /**
    This method is called when user allows push notification. This method tells the delegate that the app successfully registered with Apple Push Notification service (APNs). This is a delegate method of app which gives us the device token to use it further and convert hexadecimal token to string.
     Return a new string by concatenating the elements of the sequence in token, adding the given separator between each element. Print token in logs. Set token value to UserManager token
     If value of token after trimming is not null, call callLoginApi method from Global class. This method will return if value of email and password is null in UserManager class (in case of alert to allow push notification).
     This method will call login api in case user allows push notification (or token is obtained) after login.
     */
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
    Tells the app that a remote notification arrived that indicates there is data to be fetched. The system calls this method when your app is running in the foreground or background. If the user opens your app from the system-displayed alert (notification), the system may call this method again when your app is about to enter the foreground so that you can update your user interface and display information pertaining to the notification. This method is called when the user taps on notification. UserInfo consists data (text) of notification. Get order id from notification. Call goToOrderDetailVC method which opens OrderDetailVC.
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
     Check if current root view controller is UINaviationController by casting it as UINavigationController,if not then do nothing.
     If currently visible view controller is already OrderDetailVC, get orderNo. from body and to show order detail, a post notification is sent to OrderDetailVC with order no. from notification body.
     If visible view controller is some view controller other than OrderDetailVC, instantiate OrderDetailVC, pass body of notification to view controller, set badge no. on app icon to 0 and push the vc.
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
    ///Not in use
    class var build: String? {
        //Not in use
        get {
            return Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String
        }
    }
    ///Used in LoginVC to pass as parameter. It returns version of application fetched from application bundle
    class var version: String? {
        get {
            return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        }
    }
    ///Used in device type parameter for login api. It returns null in case of iOS.
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
     This method is not called in our application
     */
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound,.badge])
    }
}
