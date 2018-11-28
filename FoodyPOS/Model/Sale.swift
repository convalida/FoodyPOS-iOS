//
//  Sale.swift
//  FoodyPOS
//
//  Created by rajat on 26/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import Foundation

struct Sale: Codable {
    let topRestaurentSale: [AllSaleElement]
    let weekSales: JSONNull?
    let allSales: [AllSaleElement]
    
    enum CodingKeys: String, CodingKey {
        case topRestaurentSale = "TopRestaurentSale"
        case weekSales = "WeekSales"
        case allSales = "AllSales"
    }
}

struct AllSaleElement: Codable {
    let customerId, customerName, contactNumber, totalAmount, totalOrder: String?
    
    enum CodingKeys: String, CodingKey {
        case customerId = "CustomerId"
        case customerName = "CustomerName"
        case contactNumber = "ContactNumber"
        case totalAmount = "TotalAmount"
        case totalOrder = "TotalOrder"
    }
}

// MARK: Encode/decode helpers
// TODO: To Be Explained Later:
class JSONNull: Codable {
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
