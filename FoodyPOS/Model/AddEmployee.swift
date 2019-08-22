//
//  AddEmployee.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 18/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import Foundation
///Structure of AddEmployee
struct AddEmployee: Codable {
    ///Variable for Results structure
    let result: Results
    ///Variable for EmployeeDetail key whose value is array of employees with details
    let employeeDetails: [EmployeeDetail]
    
    /**
    Enum is defined here. It assigns response keys of EmployeeDetail array to corresponding variables
    */
    enum CodingKeys: String, CodingKey {
        /**
        Assign Result key to result variable which displays appropriate message and result code if api hit is successful or failure
        */
        case result = "Result"
        /**
        Assign EmployeeDetails key to employeeDetails variable which is array of all employees with their details
        */
        case employeeDetails = "EmployeeDetails"
    }
}

///Strucutre for Results object
struct Results: Codable {
    ///Variable for message key
    let message : String
    ///Variable for resultCode key
    let resultCode : String 
    
    /**
    Enum is defined here. It assigns response keys of Result object to corresponding variables
    */
    enum CodingKeys: String, CodingKey {
        ///Assign Message key to message variable which displays message accordingly if api hit is successful or failure
        case message = "Message"
        /// Assign ResultCode key to resultCode variable whose value is 1 in case of success and 0 in case of failure
        case resultCode = "ResultCode"
    }
}
