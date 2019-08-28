//
//  User.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 05/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//
//  This file defines all objects which are used for User object

import Foundation
///Structure for User or response returned from LoginByApp api
struct User:Codable {
    ///Variable for message 
    var message: String?
    ///Variable for result
    var result: String?
    ///Variable for UserName key
    var userName: String?
    ///Variable IsActive button
    var isActive: String?
    ///Variable for RestaurantId key
    var restaurantID: String?
    ///Variable for Tax key
    var tax: String? 
    ///Variable for RestaurentName key
    var restaurentName: String?
    ///Variable for Role key
    var role: String?
    
    /**
    Enum is defined here. It assigns response keys of root object to corresponding variables
    */
    enum CodingKeys: String, CodingKey {
        ///It displays appropriate message in response depending on api hit is successful or not. Not compulsory to assign key to message here
        case message
        ///It displays appropriate result code in response, if api hit is successful, it returns 1 else it returns 0. Not compulsory to assign key to message here
        case result
        ///Assign UserName key to userName variable which displays email of user
        case userName = "UserName"
        ///Assign IsActive key to isActive variable which shows active status of user logged in
        case isActive = "IsActive"
        ///Assign RestaurantId key to restaurantID variable which displays restaurant id
        case restaurantID = "RestaurantId"
        ///Assign Tax key to tax variable which displays tax percentage of restaurant
        case tax = "Tax"
        ///Assign RestaurentName key to restaurentName variable which displays restaurant name with which user is logged in
        case restaurentName = "RestaurentName"
        ///Assign Role key to role variable which shows role of user
        case role = "Role"
    }
}

///Structure for Logout, returned from LogoutByApp web service
struct Logout:Codable {
    ///Variable for message. It displays appropriate message in response depending on api hit is successful or not.
    var message: String? 
    ///Variable for result which returns 1 in case user is successfully logged out.
    var result: String?

    ///Enum is not defined here. Rajat ji please check and confirm this
}
