//
//  Order.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 14/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import Foundation
struct Order: Codable {
    let totalOrders : String?
    let totalAmount : String?
    let date : [DateElement]?
    
    enum CodingKeys: String, CodingKey {
        
        case totalOrders = "TotalOrders"
        case totalAmount = "TotalAmount"
        case date = "Date"
    }
}

struct DateElement: Codable {
    let orderDate: String?
    let orderNumberDetails: [OrderNumberDetail]?
    
    enum CodingKeys: String, CodingKey {
        case orderDate = "OrderDate"
        case orderNumberDetails = "Order_NumberDetails"
    }
}

struct OrderNumberDetail: Codable {
    let orderNo : String?
    let orderDate : String?
    let totalPrices : String?
    let pickupTime : String?
    let onClick : OnClick?
    
    enum CodingKeys: String, CodingKey {
        
        case orderNo = "OrderNo"
        case orderDate = "OrderDate"
        case totalPrices = "TotalPrices"
        case pickupTime = "PickupTime"
        case onClick = "OnClick"
    }
}

struct OnClick: Codable {
    let customerName : String?
    let email : String?
    let contactNumber : String?
    let subTotal : String?
    let taxInPercentage : String?
    let taxvalue : String?
    let tip : String?
    let grandTotal : String?
    let orderItemDetails : [OrderItemDetail]?
    
    enum CodingKeys: String, CodingKey {
        
        case customerName = "CustomerName"
        case email = "Email"
        case contactNumber = "ContactNumber"
        case subTotal = "SubTotal"
        case taxInPercentage = "TaxInPercentage"
        case taxvalue = "Taxvalue"
        case tip = "Tip"
        case grandTotal = "GrandTotal"
        case orderItemDetails = "OrderItemDetails"
    }
}

struct OrderItemDetail: Codable {
    let subitemsNames : String?
    let modifier : String?
    let addOn : String?
    let instruction : String?
    let price : String?
    let addOnPrices : String?
    let total : String?
    
    enum CodingKeys: String, CodingKey {
        
        case subitemsNames = "SubitemsNames"
        case modifier = "Modifier"
        case addOn = "AddOn"
        case instruction = "Instruction"
        case price = "Price"
        case addOnPrices = "AddOnPrices"
        case total = "Total"
    }
}
