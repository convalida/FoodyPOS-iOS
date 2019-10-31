//
//  Customers.swift
//  FoodyPOS
//
//  Created by rajat on 26/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import Foundation

//typealias Customers = [CustomersElement]

///Structure for Customers
struct Customers: Codable {
    ///Variable for ByDateSelected structure
    let byDateSelected: [ByDateSelected]
    
    /**
    Enum is defined here. It assigns response keys of By_DateSelected to corresponding variables
    */
    enum CodingKeys: String, CodingKey {
        ///Assign By_DateSelected to byDateSelected variable which returns details of customers within selected date range
        case byDateSelected = "By_DateSelected"
    }
}

/**
Structure of ByDateSelected
*/
struct ByDateSelected: Codable {
    ///Variable for CustomerName key
    let customerName: String 
    ///Variable for ContactNo key
    let contactNo: String
    ///Variable for TotalAmount key
    let totalamount: String
    ///Variable for TotalOrders key
    let totalOrders: String 
    ///Variable for CustomerId key
    let customerId: String
    let status: String
    
     /**
    Enum is defined here. It assigns response keys of customer details to corresponding variables
    */
    enum CodingKeys: String, CodingKey {
        ///Assign CustomerName key to customerName variable which displays name of customer
        case customerName = "CustomerName"
        ///Assign ContactNo key to contactNo variable which displays contact no. of customer
        case contactNo = "ContactNo"
        ///Assign Totalamount key to totalamount variable which displays total amount of customer
        case totalamount = "Totalamount"
        ///Assign TotalOrders key to totalOrders value which displays total orders of customer
        case totalOrders = "TotalOrders"
        ///Assign CustomerId key to customerId value which displays customer id of customer
        case customerId  = "CustomerId"
        case status = "Status"
    }
}

