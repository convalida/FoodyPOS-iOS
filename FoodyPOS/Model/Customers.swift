//
//  Customers.swift
//  FoodyPOS
//
//  Created by rajat on 26/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import Foundation

//typealias Customers = [CustomersElement]

struct Customers: Codable {
    let byDateSelected: [ByDateSelected]
    
    enum CodingKeys: String, CodingKey {
        case byDateSelected = "By_DateSelected"
    }
}

struct ByDateSelected: Codable {
    let customerName, contactNo, totalamount, totalOrders, customerId: String
    
    enum CodingKeys: String, CodingKey {
        case customerName = "CustomerName"
        case contactNo = "ContactNo"
        case totalamount = "Totalamount"
        case totalOrders = "TotalOrders"
        case customerId  = "CustomerId"
    }
}

