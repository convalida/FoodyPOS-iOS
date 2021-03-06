//
//  Alert.swift
//  FoodyPOS
//
//  Created by rajat on 26/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//
//  A centeral file in which all alert messages are defined.

import UIKit

///Class to dispaly different types of alerts.
class Alert: NSObject {
    
    /// Show simple alert with title and message and also action. Not used in project
    public static func showSimpleAlert(title:String, message:String, actionTitle:String, controller:UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        alert.addAction(action)
        controller.present(alert, animated: true, completion: nil)
    }
    
    ///Show alert with single button, title, message and handler to handle actions. Used in DashboardVC temprarily to show token
    public static func showSingleButtonAlert(title:String, message:String, actionTitle:String, controller:UIViewController, handler:(()-> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default) { (UIAlertAction) in
            if let hand = handler{
                hand()
            }
        }
        alert.addAction(action)
        controller.present(alert, animated: true, completion: nil)
    }
    
    /**
    Show alert with two button actions. Used in EditEmployeeVC and SignUpVC to select the role type is Manager and Employee.
    */
    public static func showDoubleButtonAlert(title:String, message:String, actionTitle1:String, actionTitle2:String, alertStyle:UIAlertControllerStyle, controller:UIViewController, handler1:(()-> Void)?, handler2:(()->Void)?){
       
        let alert = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        let action1 = UIAlertAction(title: actionTitle1, style: .default) { (UIAlertAction) in
            if let hand1 = handler1{
                hand1()
            }
        }
        let action2 = UIAlertAction(title: actionTitle2, style: .default) { (UIAlertAction) in
            if let hand2 = handler2{
                hand2()
            }
        }
        alert.addAction(action1)
        alert.addAction(action2)
        if alertStyle == .actionSheet {
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancel)
        }
        controller.present(alert, animated: true, completion: nil)
    }
    
    /// Show text field inside alert. Not used in project
    public static func showSingleTextAlertWithTitle(title:String, message:String, actionTitle:String, placeHolder:String, controller:UIViewController, handler:((UITextField)->Void)?){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = placeHolder
        }
        let action = UIAlertAction(title: actionTitle, style: .default) { (UIAlertAction) in
            let textFiled = alert.textFields?.first
            if let hand = handler{
                hand(textFiled!)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        
        controller.present(alert, animated: true, completion: nil)
    }
    
    /**
     Show alert with title, message body. Not in use in this project
     */
    public static func showDoubleTextAlert(title:String, message:String, actionTitle:String, placeHolder1:String, placeHolder2:String, isPassword:Bool, controller:UIViewController, handler:((UITextField, UITextField)->Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = placeHolder1
        }
        
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = placeHolder2
            if isPassword{
                textField.isSecureTextEntry = true
            }
        }
        
        let action = UIAlertAction(title: actionTitle, style: .default) { (UIAlertAction) in
            let text1 = alert.textFields?.first
            let text2 = alert.textFields?.last
            
            if let hand = handler{
                hand(text1!,text2!)
            }
        }
        alert.addAction(action)
        controller.present(alert, animated: true, completion: nil)
    }

    /**
     Display datepicker for date inputs with ok and cancel actions. Used in AllBestSelerVC, OrderListVC, SalesReportVC, SalesSellAllVC. For iPad, show alert as popover.
    */
    public static func showDatePicker(dataPicker:UIDatePicker, controller:UIViewController, viewRect:UIView, hander:((Date)->Void)?) {
        let alert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        alert.view.addSubview(dataPicker)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            if let hand = hander {
                hand(dataPicker.date)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        if Global.isIpad {
         let popover = alert.popoverPresentationController
            popover?.sourceView = viewRect
            popover?.sourceRect = viewRect.bounds
        }
        controller.present(alert, animated: true, completion: nil)
    }
}
