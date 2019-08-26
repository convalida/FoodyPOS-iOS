//
//  BestSeller.swift
//  FoodyPOS
//
//  Created by rajat on 26/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import Foundation

//struct BestSeller:Codable {
//    let WeeklyBestsellersItem:[Items]
//    let MonthelyBestsellersItem:[Items]
//    let YearlyBestsellersItem:[Items]
//}
//
//struct Items:Codable {
//    let Subitems:String?
//    let Counting:String?
//}

/**
Strucutre for BestSeller
*/
struct BestSeller: Codable {

    ///Variable for weekly section of LyBestseller structure. Declarations of weekly, monthly and yearly seperate. Rajat ji Please check that also if seperated declarations are correct.
    let weeklyBestsellersItem: [LyBestsellersItem?]
     ///Variable for weekly section of LyBestseller structure. 
    let monthelyBestsellersItem: [LyBestsellersItem?] 
     ///Variable for weekly section of LyBestseller structure. 
    let yearlyBestsellersItem: [LyBestsellersItem?]
    
    /**
    Enum is defined here. It assigns response keys of weekly, monthly and yearly bestseller items to corresponding variables
    */
    enum CodingKeys: String, CodingKey {
         /**
        Assign WeeklyBestsellersItem key to weeklyBestsellersItem variable which displays top 3 bestseller items of current week with their counting
        */
        case weeklyBestsellersItem = "WeeklyBestsellersItem"
         /**
        Assign MonthlyBestsellersItem key to monthlyBestsellersItem variable which displays top 3 bestseller items of current month with their counting
        */
        case monthelyBestsellersItem = "MonthelyBestsellersItem"
         /**
        Assign YearlyBestsellersItem key to yearlyBestsellersItem variable which displays top 3 bestseller items of current year with their counting
        */
        case yearlyBestsellersItem = "YearlyBestsellersItem"
    }
}

///Structure for handling response of BestSellerItems
struct LyBestsellersItem: Codable {
    ///Variable for Subitems key
    let subitems: String? 
    ///Variable for Counting key
    let counting: String?
    
    /**
    Enum is defined here. It assigns response keys of sub items and counting to corresponding variables
    */
    enum CodingKeys: String, CodingKey {
        ///Assign Subitems key subitems variable which displays item name
        case subitems = "Subitems"
        ///Assign Counting key to counting variable which displays no. of times an item was ordered
        case counting = "Counting"
    }
}
