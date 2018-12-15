//
//  User.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 05/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//
//  This file defines all objects which are used for User object

import Foundation

struct User:Codable {
    var message, result, userName, isActive: String?
    var restaurantID, tax, restaurentName, role: String?
    
    enum CodingKeys: String, CodingKey {
        case message, result
        case userName = "UserName"
        case isActive = "IsActive"
        case restaurantID = "RestaurantId"
        case tax = "Tax"
        case restaurentName = "RestaurentName"
        case role = "Role"
    }
}

struct Logout:Codable {
    var message, result: String?
}
