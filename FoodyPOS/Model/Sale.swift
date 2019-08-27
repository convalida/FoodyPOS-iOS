//
//  Sale.swift
//  FoodyPOS
//
//  Created by rajat on 26/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import Foundation
///Structure for Sales
struct Sale: Codable {
    ///Variable for AllSaleElement structure used in TopSaleVC. Rajat ji please check this    
    let topRestaurentSale: [AllSaleElement]
    ///Rajat ji please update this and also where it is used
    let weekSales: JSONNull?
     ///Variable for AllSaleElement structure used in SalesSellAllVC. Rajat ji please check this as same structure is assigned to two variables
    let allSales: [AllSaleElement]
    
    /**
    Enum is defined here. It assigns response keys of root object to corresponding variables
    */
    enum CodingKeys: String, CodingKey {
        ///Assign TopRestaurentSale key to topRestaurantSale variable, used in TopSaleVC
        case topRestaurentSale = "TopRestaurentSale"
        ///Assign WeekSales key to weekSales variable. Rajat ji please update where its used
        case weekSales = "WeekSales"
        ///Assign AllSales key to allSales variable, used in SalesSellAllVC
        case allSales = "AllSales"
    }
}

///Structure for AllSaleElement displaying customer information with no. of orders and amount
struct AllSaleElement: Codable {
    ///Variable for CustomerId key
    let customerId: String?
    ///Variable for CustomerName key
    let customerName: String?
    ///Variable for ContactNumber key
    let contactNumber: String?
    ///Variable for TotalAmount key
    let  totalAmount: String?
    ///Variable for TotalOrder key
    let totalOrder: String?
    
    /**
    Enum is defined here. It assigns response keys of each sale object to corresponding variables
    */
    enum CodingKeys: String, CodingKey {
        ///Assign CustomerId key to customerId variable which displays customer id of customer
        case customerId = "CustomerId"
        ///Assign CustomerName key to customerName variable which displays name of customer
        case customerName = "CustomerName"
        ///Assign ContactNumber key to contactNumber variable which displays contact no. of customer
        case contactNumber = "ContactNumber"
        ///Assign TotalAmount key to totalAmount variable which displays total amount of a customer
        case totalAmount = "TotalAmount"
        ///Assign TotalOrder key to totalOrder variable which displays no. of orders of a customer
        case totalOrder = "TotalOrder"
    }
}

// MARK: Encode/decode helpers
// TODO: To Be Explained Later:

///Rajat ji please update this
class JSONNull: Codable {
    ///Rajat ji please update this
    public init() {}
    
    ///Rajat ji please update this
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    ///Rajat ji please update this
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
