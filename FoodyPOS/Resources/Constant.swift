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

//MARK: UIConstant values
let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

//MARK: File instance
let appDelegate = UIApplication.shared.delegate as! AppDelegate

let Storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

let kAppName = "FoodyPOS"

let noDataMessage = "The data couldn’t be read because it is missing."
let noDataMessage1 = "The data couldn’t be read because it isn’t in the correct format."
