//
//  CustomerDetail.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 20/11/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import Foundation

///Structure of Customer details
struct CustomerDetail : Codable {
    ///Variable for Customer_Details structure
    let customer_Details : Customer_Details?
    
    /**
    Enum is defined here. It assigns response keys of Customer_Details object to corresponding variables
    */
    enum CodingKeys: String, CodingKey {
        ///Assign Customer_Details key to customer_Details variable which displays details of customer along with order details
        case customer_Details = "Customer_Details"
    }
}


///Structure for Customer_Details object
struct Customer_Details : Codable {
    ///Variable name key
    let name : String?
    ///Variable customer email key 
    let customerEmail : String?
    ///Variable for contact no. key
    let contactNo : String?
    ///Variable for Order_Details structure
    let order_Details : [Order_Details]?
    
    /**
    Enum is defined here. It assigns response keys of details of customer to corresponding variables
    */
    enum CodingKeys: String, CodingKey {
        ///Assign Name key to name variable which displays customer name
        case name = "Name"
        ///Assign CustomerEmail key customerEmail variable which displays email id of customer
        case customerEmail = "CustomerEmail"
        ///Assign ContactNo key to contactNo variable which displays contact no. of customer
        case contactNo = "ContactNo"
        ///Assign Order_Details key to order_Details variable which displays details of all orders of customer
        case order_Details = "Order_Details"
    }
}

/**
Structure Order_Details array
*/
struct Order_Details : Codable {
    ///Variable for OrderNo key
    let orderNo : String?
    ///Variable for OrderPickupDate key
    let orderPickupDate : String?
    ///Variable for OrderTime key
    let orderTime : String?
    ///Variable for SubTotal key
    let subTotal : String?
    ///Variable for TaxPer key
    let taxPer : String?
    ///Variable for TaxValue key
    let taxValue : String?
    ///Variable for Tip key
    let tip : String?
    ///Variable for Total key
    let total : String?
    ///Variable for Item_Details key
    let items_Details : [Items_Details]?
    
     /**
    Enum is defined here. It assigns response keys of details of order to corresponding variables
    */
    enum CodingKeys: String, CodingKey {
        ///Assign OrderNo key to orderNo value which displays order no.
        case orderNo = "OrderNo"
         ///Assign OrderPickupDate key to orderPickupDate value which displays pickup date of order 
        case orderPickupDate = "OrderPickupDate"
         ///Assign OrderTime key to orderTime value which displays time of order
        case orderTime = "OrderTime"
         ///Assign SubTotal key to subTotal value which displays sub total of order 
        case subTotal = "SubTotal"
         ///Assign TaxPer key to taxPer value which displays tax percentage
        case taxPer = "TaxPer"
         ///Assign TaxValue key to taxValue value which displays value of tax in $
        case taxValue = "TaxValue"
         ///Assign Tip key to tip value which displays with that order
        case tip = "Tip"
         ///Assign Total key to total value which displays total amount of order
        case total = "Total"
         ///Assign Items_Details key to items_Details value which displays details of items. In Customer details reponse, it is not present, 
        case items_Details = "Items_Details"
    }
}

///This is for describing structure of item_Details under an order detail
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
