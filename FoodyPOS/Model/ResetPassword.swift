//
//  ResetPassword.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 23/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import Foundation

///Structure for ResetPassword in OTP web service
struct ResetPassword: Codable {
    ///Variable for message key
    let message: String
    ///Variable for ResultCode key
    let resultCode: String
    
     /**
    Enum is defined here. It assigns response keys of root object to corresponding variables
    */
    enum CodingKeys: String, CodingKey {
        ///Minakshi Ji, Not compulsory to assign key to message here
        ///It displays appropriate message in reponse depending on api hit is successful or not
        case message
        ///Assign ResultCode key to resultCode variable which returns 1 in case password is successfully changed else returns 0
        case resultCode = "ResultCode"
    }
}
