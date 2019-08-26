//
//  Employee.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 07/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//
//  This file defines all objects used for an Employee

import Foundation

///Structure for Employee
struct Employee: Codable {    
    ///Variable for EmployeeDetail structure
    var employeeDetails: [EmployeeDetail]
    
    /**
    Enum is defined here. It assigns response keys of EmployeeDetails to corresponding variable
    */
    enum CodingKeys: String, CodingKey {
        ///Assign EmployeeDetails key to employeeDetails variable which displays details of all the employees
        case employeeDetails = "EmployeeDetails"
    }
}

/**
Structure for EmployeeDetail 
*/
struct EmployeeDetail: Codable {
    ///Variable for AccountId key
    let accountID: String
    ///Variable for Username key
    let username: String
    ///Variable for EmailId key
    let emailID: String
    ///Variable for RoleType key
    let roleType: String
    ///Variable for Active key
    let active: String
    
    /**
    Enum is defined here. It assigns response keys of details of employee to corresponding variable
    */
    enum CodingKeys: String, CodingKey {
        ///Assign AccountId key to accountID variable which displays unique identifier for employee
        case accountID = "AccountId"
        ///Assign Username key to username variable which displays name of employee
        case username = "Username"
        ///Assign EmailId key to emailID variable which displays email id of employee
        case emailID = "EmailId"
        ///Assign RoleType key to roleType variable which displays role of employee is manager or employee
        case roleType = "RoleType"
        ///Assign Active key to active variable which displays if employee is active or not
        case active = "Active"
    }
}
