//
//  ForgotPassword.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 07/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import Foundation

///Structure for ForgotPassword
struct ForgotPassword:Codable {
    ///Variable for message
    let message: String
    ///Variable for ResultCode key
    let resultCode: String
    
    /**
    Enum is defined here. It assigns response keys of ForgotPassword to corresponding variables
    */
    enum CodingKeys: String, CodingKey {
        ///It displays appropriate message in response depending on api hit is successful or not. Nothing is assigned here as the key is same in response
        case message
        ///Assign ResultCode key to resultCode variable which displays 1 in case of success and 0 in case of failure
        case resultCode = "ResultCode"
    }
}
