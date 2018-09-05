//
//  ForgotPassword.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 07/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import Foundation

struct ForgotPassword:Codable {
    let message, resultCode: String
    
    enum CodingKeys: String, CodingKey {
        case message
        case resultCode = "ResultCode"
    }
}
