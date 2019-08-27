//
//  Dashboard.swift
//  FoodyPOS
//
//  Created by rajat on 28/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//
//  This files defines all objects which are used on dashboard


import Foundation

///Structure for dashboard for displaying cells for label values.
struct Dashboard {

    /**Structure for Data for to store title, sub title and icon for label values.
    This used in DashboardVC to display label values.
    */ 
    
    struct Data {
        ///Variable for title for displaying key of labelValues in response
        let title:String
         ///Variable for sub title for displaying value of labelValues in response
        let subtitle:String
         ///Variable for con for displaying icon corresponding label value
        let icon:UIImage
    }
    
    ///Array to store title, sub title and and icon
    static var titleArray = [Data]()
    
    ///Structure for cell identifier. 
    struct CellIdentifier {
        ///Assign dashboardCell identifier to dashboardCell variable
        static let dashboardCell = "dashboardCell"
    }
    
}

///Structure for dashboard to parse response from server
struct Dashboard1: Codable { 
    
    ///Variable for LabelValues key
    let labelValues: LabelValues
    
    ///Variable for Chart1 structure
    let chart: Chart1
    
     /**
    Enum is defined here. It assigns response keys of LabelValues to corresponding variables
    */
    enum CodingKeys: String, CodingKey {
        ///Assign LabelValues key to labelValues variable which display weekly sales, customers, orders and total, sales, customers and orders.
        case labelValues = "LabelValues"
        ///Minakshi ji, No need to assign value if key and value is same
        case chart
    }
    
}

///Structure for chart
struct Chart1: Codable {
    
    ///Variable for Week1 structure
    let week: [Week1]
    ///Variable for Month1 structure
    let month: [Month1]
    ///Variable for Year1 structure
    let year: [Year1]
    
     /**
    Enum is defined here. It assigns response keys of Week, Month and Year to corresponding variables
    */
    enum CodingKeys: String, CodingKey {
        ///Assign Week key array to week variable
        case week = "Week"
        ///Assign Month key array to month variable
        case month = "Month"
        ///Assign Year key array to year variable
        case year = "Year"
    }
}

/// Structure for displaying monthly sales and orders on graph
struct Month1: Codable {
    ///Variable for Daydate key
    let daydate: String
    ///Variable for TotalOrders
    let totalOrders: String 
    ///Variable for TotalSale key
    let totalSale: String
    
    /**
    Enum is defined here. It assigns response keys of Daydate, TotalOrders and TotalSale to corresponding variables
    */
    enum CodingKeys: String, CodingKey {
        ///Daydate key is assigned to daydate variable which displays date of month
        case daydate = "Daydate"
        ///TotalOrders key is assigned to totalOrders variable which displays no. of orders on that date
        case totalOrders = "TotalOrders"
        ///TotalSale key is assigned to totalSale variable which displays sale in $ on that date
        case totalSale = "TotalSale"
    }
}

/// Structure for displaying weekly sales and orders on graph
struct Week1: Codable {
    ///Variable for WeekDay key
    let weekDay: String
    ///Variable for TotalOrders key
    let totalOrders: String 
    ///Variable for TotalSale key
    let totalSale: String
    
     /**
    Enum is defined here. It assigns response keys of WeekDay, TotalOrders and TotalSale to corresponding variables
    */
    enum CodingKeys: String, CodingKey {
         ///WeekDay key is assigned to weekDay variable which displays date of week
        case weekDay = "WeekDay"
        ///TotalOrders key is assigned to totalOrders variable which displays no. of orders on that date
        case totalOrders = "TotalOrders"
        ///TotalSale key is assigned to totalSale variable which displays sale in $ on that date
        case totalSale = "TotalSale"
    }
}

/// Structure for displaying yearly sales and orders on graph
struct Year1: Codable {
     ///Variable for Month key
    let month: String 
    ///Variable for TotalOrders key
    let totalOrders: String 
    ///Variable for TotalSale key
    let totalSale: String
    
     /**
    Enum is defined here. It assigns response keys of Month, TotalOrders and TotalSale to corresponding variables
    */
    enum CodingKeys: String, CodingKey {
         ///Month key is assigned to month variable which displays month of year
        case month = "Month"
          ///TotalOrders key is assigned to totalOrders variable which displays no. of orders in that month
        case totalOrders = "TotalOrders"
         ///TotalSale key is assigned to totalSale variable which displays sale in $ in that month
        case totalSale = "TotalSale"
    }
}

/// Define all keys for label values which are received in web services
struct LabelValues: Codable {
    ///Variable for TotalSale key
    let totalSale: String 
    ///Variable for TotalOrders key
    let totalOrders: String
    ///Variable for TotalCustomers key
    let totalCustomers: String 
    ///Variable for Weeksale key
    let weeksale: String
    ///Variable for WeeklyOrder key
    let weeklyOrder: String 
    ///Variable for WeekCustomer key
    let weekCustomer: String
    
     /**
    Enum is defined here. It assigns response keys of LabelValues to corresponding variables
    */
    enum CodingKeys: String, CodingKey {
        ///Assign TotalSale key to totalSale variable which displays total sale
        case totalSale = "TotalSale"
        ///Assign TotalOrders key to totalOrders variable which displays total orders
        case totalOrders = "TotalOrders"
        ///Assign TotalCustomers key to totalCustomers variable which displays total customers
        case totalCustomers = "TotalCustomers"
        ///Assign WeekSale key to weeksale variable which displays sale of current week
        case weeksale = "Weeksale"
        ///Assign WeeklyOrder key to weekly order variable which displays orders of current week
        case weeklyOrder = "WeeklyOrder"
        ///Assign WeekCustomer key to weekCustomer variable which displays customers of current week 
        case weekCustomer = "WeekCustomer"
    }
}
