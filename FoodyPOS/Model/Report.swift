//
//  Report.swift
//  FoodyPOS
//
//  Created by rajat on 26/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import Foundation

///Structure for Report
struct Report: Codable {
    ///Variable for Day structure
    let day: [Day]?
    ///Variable for Week structure
    let week: [Week]?
    ///Variable for Month structure
    let month: [Month]?
    
    /**
    Enum is defined here. It assigns response keys of root object to corresponding variables
    */
    enum CodingKeys: String, CodingKey {
        ///Assign Day key to day variable which diplays daily report of current week by default and daily report between date selection
        case day = "Day"
        ///Assign Week key to week variable which diplays weekly report of current month by default and weekly report between date selection
        case week = "Week"
        ///Assign Month key to month variable which diplays monthly report of current month by default and monthly report between date selection
        case month = "Month"
    }
}

///Structure for Daily reports
struct Day: Codable {
    ///Variable for Day key
    let day: String 
    ///Variable for Totalsales key
    let totalsales: String
    ///Variable for TotalsOrders key
    let totalsOrders: String
 //   let byDate: [ByDate]?
    
     /**
    Enum is defined here. It assigns response keys of Day object to corresponding variables
    */
    enum CodingKeys: String, CodingKey {
        ///Assign Day key to day variable which displays date with day
        case day = "Day"
        ///Assign Totalsales key to totalsales variable which displays total sale of the day
        case totalsales = "Totalsales"
        ///Assign TotalsOrders key to totalsOrders variable which displays total orders day
        case totalsOrders = "TotalsOrders"
    //    case byDate = "ByDate"
    }
}

/**struct ByDate: Codable{
    let orderDate : String?
    let totalSales : String?
    let totalOrders : String?
    let orderDetails: [OrderDetails]?
    
    enum CodingKeys: String, CodingKey{
        case orderDate = "OrderDate"
        case totalSales = "Totalsales"
        case totalOrders = "TotalsOrders"
        case orderDetails = "OrderDetails"
    }
}

struct OrderDetails: Codable{
    let orderId : String?
    let orderNumber : String?
    let orderTime : String?
    let orderTotal : String?
    
    enum CodingKeys: String, CodingKey{
        case orderId = "OrderId"
        case orderNumber = "OrderNo"
        case orderTime = "OrderTime"
        case orderTotal = "OrderTotal"
    }
}**/


///Structure for Monthly reports
struct Month: Codable {
    ///Variable for Month key
    let month: String
    ///Variable for Totalsales key
    let totalsales: String 
     ///Variable for TotalsOrders key
    let totalsOrders: String
  //  let byMonthDate: [ByMonthDate]?
    
    /**
    Enum is defined here. It assigns response keys of Month object to corresponding variables
    */
    enum CodingKeys: String, CodingKey {
         ///Assign Month key to month variable which displays month with year
        case month = "Month"
        ///Assign Totalsales key to totalsales variable which displays total sale of the month
        case totalsales = "Totalsales"
         ///Assign TotalsOrders key to totalsOrders variable which displays total orders month
        case totalsOrders = "TotalsOrders"
    //    case byMonthDate = "ByDate"
    }
}

/**struct ByMonthDate: Codable{
    let orderDate: String?
    let totalSales: String?
    let totalOrders: String?
    let monthOrderDetails: [MonthOrderDetails]?
    
    enum CodingKeys: String, CodingKey {
        case orderDate = "OrderDate"
        case totalSales = "Totalsales"
        case totalOrders = "TotalsOrders"
        case monthOrderDetails = "OrderDetails"
    }
}

struct MonthOrderDetails: Codable{
    let orderId: String?
    let orderNumber: String?
    let orderTime: String?
    let orderTotal: String?
    
    enum CodingKeys: String, CodingKey {
        case orderId = "OrderId"
        case orderNumber = "OrderNo"
        case orderTime = "OrderTime"
        case orderTotal = "Ordertotal"
    }
}**/
///Structure for Weekly reports
struct Week: Codable {
    ///Variable for Week key
    let week: String
     ///Variable for Totalsales key
    let totalsales: String 
     ///Variable for TotalsOrders key
    let totalsOrders: String
  //  let byWeekDate: [ByWeekDate]?
    
     /**
    Enum is defined here. It assigns response keys of Week object to corresponding variables
    */
    enum CodingKeys: String, CodingKey {
        ///Assign Week key to week variable which displays week range
        case week = "Week"
        ///Assign Totalsales key to totalsales variable which displays total sale of the week
        case totalsales = "Totalsales"
        ///Assign TotalsOrders key to totalsOrders variable which displays total orders week
        case totalsOrders = "TotalsOrders"
   //     case byWeekDate = "ByDate"
    }
}

/**struct ByWeekDate: Codable {
    let orderDate: String?
    let totalSales: String?
    let totalOrders: String?
    let weekOrderDetails: [WeekOrderDetails]?
    
    enum CodingKeys: String, CodingKey{
        case orderDate = "OrderDate"
        case totalSales = "Totalsales"
        case totalOrders = "TotalsOrders"
        case weekOrderDetails = "OrderDetails"
    }
}

struct WeekOrderDetails: Codable{
    let orderId: String?
    let orderNumber: String?
    let orderTime: String?
    let orderTotal: String?
    
    enum CodingKeys: String,CodingKey{
        case orderId = "OrderId"
        case orderNumber = "OrderNo"
        case orderTime = "OrderTime"
        case orderTotal = "OrderTotal"
    }
}**/


