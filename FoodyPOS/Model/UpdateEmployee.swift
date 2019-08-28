//
//  UpdateEmployee.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 18/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import Foundation
///Structure for UpdateEmployee
struct UpdateEmployee: Codable {
    ///Variable for Message key
    let message: String
    ///Variable for ResultCode key
    let resultCode: String
    
    /**
    Enum is defined here. It assigns response keys of root object to corresponding variables
    */
    enum CodingKeys: String, CodingKey {
        ///Message key is assigned to message variable which displays apporpriate message based on api hit is successful or not 
        case message = "Message"
        ///ResultCode key is assigned to resultCode variable which displays 1 in case api hit is successful and 0 in case of unsuccessful
        case resultCode = "ResultCode"
    }
}
