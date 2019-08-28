//
//  OrderSearch.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 20/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import Foundation

///Structure for order no. search
struct OrderSearch: Codable {
    ///Variable for ByOrderNumber structure
    let byOrderNumber: [ByOrderNumber]
    
    /**
    Enum is defined here. It assigns response key By_OrderNumber to corresponding variables
    */
    enum CodingKeys: String, CodingKey {
        ///Assign By_OrderNumber key to byOrderNumber variable which displays detail of a particular order
        case byOrderNumber = "By_OrderNumber"
    }
}

///Structure for ByOrderNumber
struct ByOrderNumber: Codable {
    ///Variable Message key
    let message: String?
    ///Variable for ResultCode key
    let resultCode: String?
    ///Variable for OrderNo key
    let orderNo: String?
    ///Variable for OrderDate key
    let orderDate: String? 
    ///Variable for TotalPrices key
    let totalPrices: String?
    ///Variable for PickupTime key
    let pickupTime: String?
    ///Variable for OnClick structure inside Order.swift
    let onClick: OnClick?
    
    /**
    Enum is defined here. It assigns response keys inside By_OrderNumber to corresponding variables
    */
    enum CodingKeys: String, CodingKey {
        ///Assign OrderNo key to orderNo variable which displays order no. of order
        case orderNo = "OrderNo"
         ///Assign OrderDate key to orderDate variable which displays order date of of a particular order
        case orderDate = "OrderDate"
        ///Assign TotalPrices key to totalPrices variable which displays total price of of a particular order
        case totalPrices = "TotalPrices"
        ///Assign PickupTime key to pickupTime variable which displays pickup time of of a particular order
        case pickupTime = "PickupTime"
        ///Assign OnClick key to onClick variable which displays order details on click of particular order inside Order.swift
        case onClick = "OnClick"
        ///Assign Message key to message variable which displays appropriate message if api hit is not successful
        case message = "Message"
        ///Assign ResultCode key to resultCode variable which returns 0 if api hit is not successful
        case resultCode = "ResultCode"

        ///Structure of onClick and its children defined in Order.swift, as earlier, response for OnClick was returned in Orderlist
    }
}
