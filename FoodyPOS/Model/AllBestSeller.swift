//
//  AllBestSeller.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 22/11/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import Foundation

///Structure for AllBestSeller
struct AllBestSeller : Codable {
    ///Variable for By_DateSelection structure
    let by_DateSelection : By_DateSelection?
    
    /**
    Enum is defined here. It assigns response keys of By_DateSelection object to corresponding variables
    */
    enum CodingKeys: String, CodingKey {

       ///Assign By_DateSelection key to by_DateSelection variable which displays weekly, monthly and yearly bestseller items
        case by_DateSelection = "By_DateSelection"
    }
}

///Structure for By_DateSelection
struct By_DateSelection : Codable {
    ///Variable for weekly bestseller items array key
    let weeklyBestsellerItems : [WeeklyBestsellerItems]?
    ///Variable for monthly bestseller items array key
    let monthlyBestsellerItems : [MonthlyBestsellerItems]?
    ///Variable for yearly bestseller items array key
    let yearlyBestsellerItems : [YearlyBestsellerItems]?
    
    /**
    Enum is defined here. It assigns response keys of WeeklyBestsellerItems, MonthlyBestsellerItems and YearlyBestsellerItems array to corresponding variables
    */
    enum CodingKeys: String, CodingKey {
        ///Assign WeeklyBestsellerItems key to weeklyBestsellerItems variable which displays bestseller items of current week 
        case weeklyBestsellerItems = "WeeklyBestsellerItems"
         ///Assign MonthlyBestsellerItems key to monthlyBestsellerItems variable which displays bestseller items of current month
        case monthlyBestsellerItems = "MonthlyBestsellerItems"
         ///Assign YearlyBestsellerItems key to yearlyBestsellerItems variable which displays bestseller items of current year
        case yearlyBestsellerItems = "YearlyBestsellerItems"
    }
}

/**
Structure of weekly bestseller items
*/
struct WeeklyBestsellerItems : Codable {
    ///Variable for Week key
    let week : String?
    ///Variable for ItemDetails array key
    let items_Details : [ItemsDetails]?
    
     /**
    Enum is defined here. It assigns response keys of Week and Item_Details to corresponding variables
    */
    enum CodingKeys: String, CodingKey {
        
        /**
        Assign Week key to week variable, which displays the week range of current week if null is passed, 
        if date range is passed, then week range of all weeks between that date selection is displayed
        */
        case week = "Week"
         ///Assign Items_Details array key to items_Details variable, which displays array of sub item names and their counting
        case items_Details = "Items_Details"
    }
}

/**
Structure of monthly bestseller items
*/
struct MonthlyBestsellerItems : Codable {
    ///Variable for Month key
    let month : String?
     ///Variable for ItemDetails array key
    let items_Details : [ItemsDetails]?
    
     /**
    Enum is defined here. It assigns response keys of Month and Item_Details to corresponding variables
    */
    enum CodingKeys: String, CodingKey {
        
        /**
        Assign Month key to month variable, which displays current month with year if null is passed, 
        if date is passed, then all months with year between that date selection is displayed
        */
        case month = "Month"
         ///Assign Items_Details array key to items_Details variable, which displays array of sub item names and their counting
        case items_Details = "Items_Details"
    }
}

/**
Structure of monthly bestseller items
*/
struct YearlyBestsellerItems : Codable {

    ///Variable for Month key 
    let year : String?
     ///Variable for ItemDetails array key
    let items_Details : [ItemsDetails]?
    
    /**
    Enum is defined here. It assigns response keys of Year and Item_Details to corresponding variables
    */
    enum CodingKeys: String, CodingKey {
        
         /**
        Assign Year key to year variable, which displays current year if null is passed, 
        if date range is passed, then all years between that date selection is displayed
        */
        case year = "Year"
        ///Assign Items_Details array key to items_Details variable, which displays array of sub item names and their counting
        case items_Details = "Items_Details"
    }
}

///Structure for Items details array
struct ItemsDetails : Codable {
    /// Variable for sub items name
    let subitems : String?
    ///Variable for counting key
    let counting : String?
    
    /**
    Enum is defined here. It assigns response keys of sub items and counting to corresponding variables
    */
    enum CodingKeys: String, CodingKey {
        
        ///Assign Subitems key to subitems variable which display sub item name
        case subitems = "Subitems"
        ///Assign Counting key to counting variable which display no. of times the item is ordered in particular period
        case counting = "Counting"
    }
}
