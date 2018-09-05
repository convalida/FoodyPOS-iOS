//
//  AddEmployee.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 18/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import Foundation
struct AddEmployee: Codable {
    let result: Results
    let employeeDetails: [EmployeeDetail]
    
    enum CodingKeys: String, CodingKey {
        case result = "Result"
        case employeeDetails = "EmployeeDetails"
    }
}

struct Results: Codable {
    let message, resultCode: String
    
    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case resultCode = "ResultCode"
    }
}
