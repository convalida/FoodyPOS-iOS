//
//  ChangePassword.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 16/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import Foundation

struct ChangePassword: Codable {
    let message, resultCode: String
    
    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case resultCode = "ResultCode"
    }
}
