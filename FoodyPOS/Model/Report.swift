//
//  Report.swift
//  FoodyPOS
//
//  Created by rajat on 26/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import Foundation

struct Report: Codable {
    let day: [Day]
    let week: [Week]
    let month: [Month]
    
    enum CodingKeys: String, CodingKey {
        case day = "Day"
        case week = "Week"
        case month = "Month"
    }
}

struct Day: Codable {
    let day, totalsales, totalsOrders: String
    
    enum CodingKeys: String, CodingKey {
        case day = "Day"
        case totalsales = "Totalsales"
        case totalsOrders = "TotalsOrders"
    }
}

struct Month: Codable {
    let month, totalsales, totalsOrders: String
    
    enum CodingKeys: String, CodingKey {
        case month = "Month"
        case totalsales = "Totalsales"
        case totalsOrders = "TotalsOrders"
    }
}

struct Week: Codable {
    let week, totalsales, totalsOrders: String
    
    enum CodingKeys: String, CodingKey {
        case week = "Week"
        case totalsales = "Totalsales"
        case totalsOrders = "TotalsOrders"
    }
}
