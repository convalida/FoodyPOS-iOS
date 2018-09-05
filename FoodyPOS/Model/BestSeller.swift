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

struct BestSeller: Codable {
    let weeklyBestsellersItem, monthelyBestsellersItem, yearlyBestsellersItem: [LyBestsellersItem?]
    
    enum CodingKeys: String, CodingKey {
        case weeklyBestsellersItem = "WeeklyBestsellersItem"
        case monthelyBestsellersItem = "MonthelyBestsellersItem"
        case yearlyBestsellersItem = "YearlyBestsellersItem"
    }
}

struct LyBestsellersItem: Codable {
    let subitems, counting: String?
    
    enum CodingKeys: String, CodingKey {
        case subitems = "Subitems"
        case counting = "Counting"
    }
}
