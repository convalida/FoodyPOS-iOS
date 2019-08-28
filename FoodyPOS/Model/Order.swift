//
//  Order.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 14/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import Foundation
///Structure for Order list
struct Order: Codable {
    ///Variable for TotalOrders
    let totalOrders : String?
    ///Variable for TotalAmount
    let totalAmount : String?
    ///Variable for DateElement structure
    let date : [DateElement]?
    
     /**
    Enum is defined here. It assigns response keys of root object to corresponding variables
    */
    enum CodingKeys: String, CodingKey {
        
        ///Assign TotalOrders key to totalOrders variable which displays total no. of orders in selected date range
        case totalOrders = "TotalOrders"
        ///Assign TotalAmount key to totalAmount variable which displays total amount in selected date range
        case totalAmount = "TotalAmount"
        ///Assign Date array key to date variable which displays all dates with details of all orders on dates
        case date = "Date"
    }
}

///Structure for Date array
struct DateElement: Codable 
{
    ///Variable for OrderDate key
    let orderDate: String?
    ///Variable for Order_NumberDetails key
    let orderNumberDetails: [OrderNumberDetail]?
    
    /**
    Enum is defined here. It assigns response keys OrderDate and Order_NumberDetails to corresponding variables
    */
    enum CodingKeys: String, CodingKey {
        ///Assign OrderDate key to orderDate variable which displays the date of order
        case orderDate = "OrderDate"
        ///Assign Order_NumberDetails key to orderNumberDetails variable which displays information about all orders on particular date
        case orderNumberDetails = "Order_NumberDetails"
    }
}

///Structure for OrderNumberDetails array
struct OrderNumberDetail: Codable {
    ///Variable for OrderNo key
    let orderNo : String?
    ///Variable for OrderDate key
    let orderDate : String?
    ///Variable for TotalPrices key
    let totalPrices : String?
    ///Variable for PickupTime key
    let pickupTime : String?
    ///This is no longer returned in response. Eariler it was returned in response but it was changed. 
    let onClick : OnClick?
    
     /**
    Enum is defined here. It assigns response keys Order_NumberDetails to corresponding variables
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
        ///Assign OnClick key to onClick variable. This is no longer returned in response. Eariler it was returned in response but it was changed. 
        case onClick = "OnClick"
    }
}


///Structure for OnClick object. This struct is accessible throughout the project and is used OrderSearch
struct OnClick: Codable {
    ///Variable for CUstomerId key
    let customerId : String?
    ///Variable for CustomerName key
    let customerName : String?
    ///Variable for Email key
    let email : String?
    ///Variable for ContactNumber key
    let contactNumber : String?
    ///Variable for SubTotal key
    let subTotal : String?
    ///Variable for TaxInPercentage key
    let taxInPercentage : String?
    ///Variable for TaxValue key
    let taxvalue : String?
    ///Variable for Tip key
    let tip : String?
    ///Variable for GrandTotal key
    let grandTotal : String?
    ///Variable for OrderItemDetail structure
    let orderItemDetails : [OrderItemDetail]?

     /**
    Enum is defined here. It assigns response keys OnClick object to corresponding variables
    */
    enum CodingKeys: String, CodingKey {
        ///Assign CustomerId key to customerId variable which displays customer id of customer
        case customerId = "CustomerId"
        ///Assign CustomerName key to customerName variable which displays customer name of customer
        case customerName = "CustomerName"
        ///Assign Email key to email variable which displays email id of customer
        case email = "Email"
        ///Assign ContactNumber key to contactNumber variable which displays contact no. of customer
        case contactNumber = "ContactNumber"
        ///Assign SubTotal key to subTotal variable which displays sub total amount of order
        case subTotal = "SubTotal"
        ///Assign TaxInPercentage key to taxInPercentage variable variable which displays tax in percentage of restuarant
        case taxInPercentage = "TaxInPercentage"
        ///Assign Taxvalue key to taxValue variable which displays tax value
        case taxvalue = "Taxvalue"
        ///Assign Tip key to tip variable which displays tip paid by customer
        case tip = "Tip"
        ///Assign GrandTotal key to grandTotal variable which displays grand total of order
        case grandTotal = "GrandTotal"
        ///Assign OrderItemDetails key to orderItemDetails variable which displays item details
        case orderItemDetails = "OrderItemDetails"
    }
}

///Structure for item details. This struct is accessible throughout the project and is used OrderSearch
struct OrderItemDetail: Codable {
    ///Variable for SubitemsNames key
    let subitemsNames : String?
    ///Variable for Modifier key
    let modifier : String?
    ///Variable for AddOn key
    let addOn : String?
    ///Variable for Instruction key
    let instruction : String?
    ///Variable for Price key
    let price : String?
    ///Variable for AddOnPrices key
    let addOnPrices : String?
    ///Variable for Total key
    let total : String?
    
    /**
    Enum is defined here. It assigns response keys OrderItemDetail object to corresponding variables
    */
    enum CodingKeys: String, CodingKey {
        
        ///Assign SubitemsNames key to subitemsNames variable which displays item name
        case subitemsNames = "SubitemsNames"
        ///Assign Modifier key to modifier variable which displays modifier in item
        case modifier = "Modifier"
        ///Assign AddOn key to addOn variable which displays add on in item
        case addOn = "AddOn"
        ///Assign Instruction key to instruction variable which displays instructions with order
        case instruction = "Instruction"
        ///Assign Price key to price variable which displays price of item
        case price = "Price"
        ///Assign AddOnPrices key to addOnPrices variable which displays add on price to item
        case addOnPrices = "AddOnPrices"
        ///Assign Total key to total variable which displays total amount of order
        case total = "Total"
    }
}
