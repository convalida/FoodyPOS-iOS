//
//  OrderSearch.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 20/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import Foundation

struct OrderSearch: Codable {
    let byOrderNumber: [ByOrderNumber]
    
    enum CodingKeys: String, CodingKey {
        case byOrderNumber = "By_OrderNumber"
    }
}

struct ByOrderNumber: Codable {
    let message, resultCode: String?
    let orderNo, orderDate, totalPrices, pickupTime: String?
    let onClick: OnClick?
    
    enum CodingKeys: String, CodingKey {
        case orderNo = "OrderNo"
        case orderDate = "OrderDate"
        case totalPrices = "TotalPrices"
        case pickupTime = "PickupTime"
        case onClick = "OnClick"
        case message = "Message"
        case resultCode = "ResultCode"
    }
}
