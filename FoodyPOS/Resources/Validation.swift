//
//  Validation.swift
//  FoodyPOS
//
//  Created by rajat on 26/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//
//  All Regular Expressions and Validation patterns are defined in this file for reusability

import Foundation

///Structure for regular expressions
struct Regex {
    ///Regular expression for user name allowing small and capital alphabets and length between 3 and 30. Rajat ji please check this.
    static let userNameRegex   = "^[a-zA-Z ]{3,30}$"
    ///Regular expression for phone no. allowing nos. between 0 and 9 and length between 6 to 15.
    static let phoneRegex      = "^[0-9]{6,15}$"
    ///Regular expression for password allowing length between 8 and 15. Rajat ji please check
    static let passwordRegex   = "^.{8,15}$"//"^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,15}$"
    ///Regular expression for email
    static let emailRegex      = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
     ///Regular expression for email and phone no. Rajat ji please check
    static let emailPhoneRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$|^([0-9]{10,13})$"
}

extension String {
    
    ///Check for valid user name. Not in use
    var isValidUserName:Bool {
            return testThe(regex: Regex.userNameRegex)
    }
    
    ///Check for valid mobile number. Not in use
    var isValidMobileNumber: Bool {
            return testThe(regex: Regex.phoneRegex)
        }
    
    ///Check for valid password. Used in LoginVC, SignUpVC, ChangePasswordVC, ResetPasswordVC
    var isValidPassword:Bool {
            return testThe(regex: Regex.passwordRegex)
    }
    
    ///Check for valid email id. Used in LoginVC, SignUpVC, ForgotPasswordVC
    var isValidEmailId:Bool {
            return testThe(regex: Regex.emailRegex)
    }
    
    ///Check for email address and phone number. Not used in project
    var isValidEmailAndNumber:Bool {
        return testThe(regex: Regex.emailPhoneRegex)
    }
    
    ///To test a particular regular expression with the given string
    func testThe(regex:String) -> Bool {
     if self.count > 0 {
        let predicate = NSPredicate(format: "SELF MATCHES %@",regex)
        return predicate.evaluate(with: self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines))
        }
       return false
    }
}
