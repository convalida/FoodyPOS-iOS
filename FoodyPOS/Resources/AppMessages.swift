//
//  AppMessages.swift
//  FoodyPOS
//
//  Created by rajat on 26/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//
//  All Messages which are displayed at various screens of the applications are
//  defined in this file so that we can change and update message from a centeral file.

import Foundation

/**
 Enum for messages. All Messages which are displayed at various screens of the applications are defined in this file so that we can change and update message from a centeral file.
 */
enum AppMessages {
 
    ///Message for name required. Used in SignUpVC
    static let msgNameRequired = "Please enter the name"
    ///Message for email required. Used in SignUpVC, LoginVC, ForgotPasswordVC
    static let msgEmailRequired = "Please enter email."
    ///Message for valid email address. Used in SignUpVC, LoginVC, ForgotPasswordVC
    static let msgValidEmail = "Please enter a valid email address."
    ///Message for password required. Used in SignUpVC, LoginVC
    static let msgPasswordRequired = "Please enter the password."
    ///Message for confirm password required. Used in SignUpVC
    static let msgCnfrmPassRequired = "Please enter the confirm password."
    ///Message for invalid password. Not used
    static let msgInvalidPassword = "Please enter a vaild password."
    /**
 Message for permitted password length range. Used in SignUpVC, LoginVC, ChangePasswordVC, ResetPasswordVC
 */
    static let msgPasswordLength = "Password must be 8 to 15 characters long."
    ///Message for first name required. Not used
    static let msgFirstNameRequired = "Please enter first name."
    ///Message for last name required. Not used
    static let msgLastNameRequired = "Please enter last name."
    ///Message for mismatching passwords. Used in SignUpVC, ChangePasswordVC, ResetPasswordVC
    static let msgPasswordNotMatch = "Password do not matched."
    ///Message for successful reset of password. Not used
    static let msgPasswordResetSuccess = "Password reset successfully."
    ///Message for invalid phone number. Not used
    static let msgInvalidPhone = "Invalid phone number."
    ///Message for phone number required. Not used
    static let msgRequiredPhone = "Please enter phone number."
    ///Message for invalid phone no. and mail. Not used
    static let msgInvalidEmailPhone = "Please enter a valid email or phone number."
    ///Message for successful update of password. Not used
    static let msgPasswordUpdate = "Password updated successfully."
    ///Message for zip code required. Not used
    static let msgZipCodeRequired = "Please enter zipcode."
    ///Message for I am a text required. Not used
    static let msgIamARequired = "Please enter \"I am a\"."
    ///Message for failure connecting to server. Used throughout the app
    static let msgFailed = "Unable to connect to server. Please try after some time."
   
   
}
