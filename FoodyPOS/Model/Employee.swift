//
//  Employee.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 07/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//
//  This file defines all objects used for an Employee

import Foundation

struct Employee: Codable {    
    var employeeDetails: [EmployeeDetail]
    
    enum CodingKeys: String, CodingKey {
        case employeeDetails = "EmployeeDetails"
    }
}

struct EmployeeDetail: Codable {
    let accountID, username, emailID, roleType: String
    let active: String
    
    enum CodingKeys: String, CodingKey {
        case accountID = "AccountId"
        case username = "Username"
        case emailID = "EmailId"
        case roleType = "RoleType"
        case active = "Active"
    }
}
