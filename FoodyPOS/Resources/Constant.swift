//
//  Constant.swift
//  FoodyPOS
//
//  Created by rajat on 26/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//
//  All application constants which are used throughout the application are defined here

import Foundation
import UIKit

/// Constant values for screen width
let SCREEN_WIDTH = UIScreen.main.bounds.size.width
/// Constant values for screen width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

///File instance for app delegate class
let appDelegate = UIApplication.shared.delegate as! AppDelegate
///Instantiate storyboard
let Storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

///Constant for app name
let kAppName = "FoodyPOS"

///Message received from web services if there is any error.
let noDataMessage = "The data couldn’t be read because it is missing."
///Message received from web services if there is any error.
let noDataMessage1 = "The data couldn’t be read because it isn’t in the correct format."

///Constant for Order detail notification
let kOrderDetailNotification = "kOrderDetailsNotification"
