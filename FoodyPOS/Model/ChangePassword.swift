//
//  ChangePassword.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 16/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import Foundation

///Strucutre of ChangePassword
struct ChangePassword: Codable {
    ///Variable for Message key
    let message : String
    ///Variable for ResultCode key
    let resultCode: String
    
    /**
    Enum is defined here. It assigns response keys of message and result code to corresponding variables
    */
    enum CodingKeys: String, CodingKey {
        ///Assign Message key to message variable which displays appropriate message based on api hit is successful or not
        case message = "Message"
        ///Assign ResultCode key to resultCode variable which displays 1 if password change is successful, 0 if it is unsuccessful
        case resultCode = "ResultCode"
    }
}
