//
//  AllBestSeller.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 22/11/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import Foundation

struct AllBestSeller : Codable {
    let by_DateSelection : By_DateSelection?
    
    enum CodingKeys: String, CodingKey {
        
        case by_DateSelection = "By_DateSelection"
    }
}

struct By_DateSelection : Codable {
    let weeklyBestsellerItems : [WeeklyBestsellerItems]?
    let monthlyBestsellerItems : [MonthlyBestsellerItems]?
    let yearlyBestsellerItems : [YearlyBestsellerItems]?
    
    enum CodingKeys: String, CodingKey {
        
        case weeklyBestsellerItems = "WeeklyBestsellerItems"
        case monthlyBestsellerItems = "MonthlyBestsellerItems"
        case yearlyBestsellerItems = "YearlyBestsellerItems"
    }
}

struct WeeklyBestsellerItems : Codable {
    let week : String?
    let items_Details : [ItemsDetails]?
    
    enum CodingKeys: String, CodingKey {
        
        case week = "Week"
        case items_Details = "Items_Details"
    }
}

struct MonthlyBestsellerItems : Codable {
    let month : String?
    let items_Details : [ItemsDetails]?
    
    enum CodingKeys: String, CodingKey {
        
        case month = "Month"
        case items_Details = "Items_Details"
    }
}

struct YearlyBestsellerItems : Codable {
    let year : String?
    let items_Details : [ItemsDetails]?
    
    enum CodingKeys: String, CodingKey {
        
        case year = "Year"
        case items_Details = "Items_Details"
    }
}

struct ItemsDetails : Codable {
    let subitems : String?
    let counting : String?
    
    enum CodingKeys: String, CodingKey {
        
        case subitems = "Subitems"
        case counting = "Counting"
    }
}
