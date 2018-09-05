//
//  Validation.swift
//  FoodyPOS
//
//  Created by rajat on 26/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//
//  All Regular Expressions and Validation patterns are defined in this file for reusability

import Foundation

struct Regex {
    static let userNameRegex   = "^[a-zA-Z ]{3,30}$"
    static let phoneRegex      = "^[0-9]{6,15}$"
    static let passwordRegex   = "^.{8,15}$"//"^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,15}$" 
    static let emailRegex      = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    static let emailPhoneRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$|^([0-9]{10,13})$"
}

extension String {
    
    var isValidUserName:Bool {
            return testThe(regex: Regex.userNameRegex)
    }
    
    var isValidMobileNumber: Bool {
            return testThe(regex: Regex.phoneRegex)
        }
    
    var isValidPassword:Bool {
            return testThe(regex: Regex.passwordRegex)
    }
    
    var isValidEmailId:Bool {
            return testThe(regex: Regex.emailRegex)
    }
    
    var isValidEmailAndNumber:Bool {
        return testThe(regex: Regex.emailPhoneRegex)
    }
    
    func testThe(regex:String) -> Bool {
     if self.count > 0 {
        let predicate = NSPredicate(format: "SELF MATCHES %@",regex)
        return predicate.evaluate(with: self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines))
        }
       return false
    }
}
