//
//  UserManager.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 09/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import Foundation

///Class for saving and retrieving data used throughout the project. Rajat ji please check this 
class UserManager {
    /**
    Method to save data to UserDefaults using User.swift class. Rajat ji please check this
    If userName, isActive, restaurantID, tax, restaurantName, role in User class is not null, set userName, isActive,
    restaurantID, tax, restaurantName, role to values of User.swift class. If value of role is Manager, set isManager to true, else set isManager to false.
    */
    static func saveUserDataIntoDefaults(user:User) {
        
        if let userName = user.userName {
            self.userName = userName
        }
        
        if let isActive = user.isActive {
            self.isActive = isActive
        }
        
        if let restaurantID = user.restaurantID {
            self.restaurantID = restaurantID
        }
        
        if let tax = user.tax {
            self.tax = tax
        }
        
        if let restaurentName = user.restaurentName {
            self.restaurentName = restaurentName
        }
        
        if let role = user.role {
            self.role = role
            if role == "Manager" {
                self.isManager = true
            }else {
                self.isManager = false
            }
        }
    }
    
    /// Get and set userName
    public static var userName:String? {
        set(newValue) {
            UserDefaults.standard.setValue(newValue, forKey: "userName")
        }
        get {
            return UserDefaults.standard.value(forKey: "userName") as? String
        }
    }
    
    /// Get and set isActive status
    public static var isActive:String? {
        set(newValue) {
            UserDefaults.standard.setValue(newValue, forKey: "isActive")
        }
        get {
            return UserDefaults.standard.value(forKey: "isActive") as? String
        }
    }

    /// Get and set restaurantID
    public static var restaurantID:String? {
        set(newValue) {
            UserDefaults.standard.setValue(newValue, forKey: "restaurantID")
        }
        get {
            return UserDefaults.standard.value(forKey: "restaurantID") as? String
        }
    }
    
    /// Get and set tax
    public static var tax:String? {
        set(newValue) {
            UserDefaults.standard.setValue(newValue, forKey: "tax")
        }
        get {
            return UserDefaults.standard.value(forKey: "tax") as? String
        }
    }
    
    /// Get and set restaurentName
    public static var restaurentName:String? {
        set(newValue) {
            UserDefaults.standard.setValue(newValue, forKey: "restaurentName")
        }
        get {
            return UserDefaults.standard.value(forKey: "restaurentName") as? String
        }
    }
    
    /// Get and set role
    public static var role:String? {
        set(newValue) {
            UserDefaults.standard.setValue(newValue, forKey: "role")
        }
        get {
            return UserDefaults.standard.value(forKey: "role") as? String
        }
    }
    
    /// Get and set isRemember
    public static var isRemember:Bool {
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "isRemember")
        }
        get {
            return UserDefaults.standard.bool(forKey: "isRemember")
        }
    }
    
    /// Get and set email
    public static var email:String? {
        set(newValue) {
            UserDefaults.standard.setValue(newValue, forKey: "email")
        }
        get {
            return UserDefaults.standard.value(forKey: "email") as? String
        }
    }
    
    /// Get and set password
    public static var password:String? {
        set(newValue) {
            UserDefaults.standard.setValue(newValue, forKey: "password")
        }
        get {
            return UserDefaults.standard.value(forKey: "password") as? String
        }
    }
    
    /// Get and set isManager
    public static var isManager:Bool {
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "isManager")
        }
        get {
            return UserDefaults.standard.bool(forKey: "isManager")
        }
    }
    
    /// Get and set isLogin
    public static var isLogin:Bool {
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "isLogin")
        }
        get {
            return UserDefaults.standard.bool(forKey: "isLogin")
        }
    }
    
    ///Get and set token
    public static var token:String? {
        set(newValue) {
            UserDefaults.standard.setValue(newValue, forKey: "token")
        }
        get {
            return UserDefaults.standard.value(forKey: "token") as? String
        }
    }
}


