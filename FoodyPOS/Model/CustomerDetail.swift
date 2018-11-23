//
//  CustomerDetail.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 20/11/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import Foundation

struct CustomerDetail : Codable {
    let customer_Details : Customer_Details?
    
    enum CodingKeys: String, CodingKey {
        case customer_Details = "Customer_Details"
    }
}


struct Customer_Details : Codable {
    let name : String?
    let customerEmail : String?
    let contactNo : String?
    let order_Details : [Order_Details]?
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case customerEmail = "CustomerEmail"
        case contactNo = "ContactNo"
        case order_Details = "Order_Details"
    }
}

struct Order_Details : Codable {
    let orderNo : String?
    let orderPickupDate : String?
    let orderTime : String?
    let subTotal : String?
    let taxPer : String?
    let taxValue : String?
    let tip : String?
    let total : String?
    let items_Details : [Items_Details]?
    
    enum CodingKeys: String, CodingKey {
        case orderNo = "OrderNo"
        case orderPickupDate = "OrderPickupDate"
        case orderTime = "OrderTime"
        case subTotal = "SubTotal"
        case taxPer = "TaxPer"
        case taxValue = "TaxValue"
        case tip = "Tip"
        case total = "Total"
        case items_Details = "Items_Details"
    }
}

struct Items_Details : Codable {
    let itemsNames : String?
    let itemPrice : String?
    let modifier : String?
    let modifierPrices : String?
    let addOn : String?
    let addOnPrices : String?
    
    enum CodingKeys: String, CodingKey {
        case itemsNames = "ItemsNames"
        case itemPrice = "ItemPrice"
        case modifier = "Modifier"
        case modifierPrices = "ModifierPrices"
        case addOn = "AddOn"
        case addOnPrices = "AddOnPrices"
    }
}
