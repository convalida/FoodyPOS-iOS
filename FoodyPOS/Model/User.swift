//
//  User.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 05/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import Foundation

struct User:Decodable {
    let message:String?
    let result:String?
    let UserName:String?
    let IsActive:String?
    let RestaurantId:String?
    let Tax:String?
    let RestaurentName:String?
    let Role:String?
}
