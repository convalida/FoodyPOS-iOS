//
//  Notifications.swift
//  FoodyPOS
//
//  Created by Minakshi Sadana on 01/11/19.
//  Copyright © 2019 com.tutist. All rights reserved.
//

import UIKit

struct Notifications: Codable {
    let notificationDetails: [NotificationDetails?]
    
    enum CodingKeys: String, CodingKey{
        case notificationDetails = "Notification_Details"
    }
}

struct NotificationDetails: Codable{
    let orderNo: String
    let status: String
    let message: String
    let orderDate: String
    let orderTime: String
    let deviceType: String
    
    enum CodingKeys: String, CodingKey{
        case orderNo = "OrderNo"
        case status = "Status"
        case message = "Message"
        case orderDate = "OrderDate"
        case orderTime = "OrderTime"
        case deviceType = "DeviceType"
    }
}
