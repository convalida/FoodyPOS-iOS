//
//  Dashboard.swift
//  FoodyPOS
//
//  Created by rajat on 28/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//
//  This files defines all objects which are used on dashboard


import Foundation

struct Dashboard {
    
    struct Data {
        let title:String
        let subtitle:String
        let icon:UIImage
    }
    
    static var titleArray = [Data]()
    
    struct CellIdentifier {
        static let dashboardCell = "dashboardCell"
    }
    
}

struct Dashboard1: Codable {
    
    let labelValues: LabelValues
    
    let chart: Chart1
    
    enum CodingKeys: String, CodingKey {
        case labelValues = "LabelValues"
        case chart
    }
    
}

struct Chart1: Codable {
    
    let week: [Week1]
    let month: [Month1]
    let year: [Year1]
    
    enum CodingKeys: String, CodingKey {
        case week = "Week"
        case month = "Month"
        case year = "Year"
    }
}

/// Structure for displaying monthly sales and orders on graph
struct Month1: Codable {
    let daydate, totalOrders, totalSale: String
    
    enum CodingKeys: String, CodingKey {
        case daydate = "Daydate"
        case totalOrders = "TotalOrders"
        case totalSale = "TotalSale"
    }
}

/// Structure for displaying weekly sales and orders on graph
struct Week1: Codable {
    let weekDay, totalOrders, totalSale: String
    
    enum CodingKeys: String, CodingKey {
        case weekDay = "WeekDay"
        case totalOrders = "TotalOrders"
        case totalSale = "TotalSale"
    }
}

/// Structure for displaying yearly sales and orders on graph
struct Year1: Codable {
    let month, totalOrders, totalSale: String
    
    enum CodingKeys: String, CodingKey {
        case month = "Month"
        case totalOrders = "TotalOrders"
        case totalSale = "TotalSale"
    }
}

/// Define all keys which are received in web services
struct LabelValues: Codable {
    let totalSale, totalOrders, totalCustomers, weeksale: String
    let weeklyOrder, weekCustomer: String
    
    enum CodingKeys: String, CodingKey {
        case totalSale = "TotalSale"
        case totalOrders = "TotalOrders"
        case totalCustomers = "TotalCustomers"
        case weeksale = "Weeksale"
        case weeklyOrder = "WeeklyOrder"
        case weekCustomer = "WeekCustomer"
    }
}
