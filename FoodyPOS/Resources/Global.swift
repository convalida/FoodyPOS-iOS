//
//  Global.swift
//  AutomobileFirst
//
//  Created by rajat on 28/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import Foundation
import UIKit

class Global:NSObject {
    
    static func showHud(){
         DispatchQueue.main.async {
            ARSLineProgress.showWithPresentCompetionBlock {
                print("API Calling Start")
            }
        }
    }
    
    static func hideHud() {
        DispatchQueue.main.async {
            ARSLineProgress.hideWithCompletionBlock {
                print("API Calling Stop")
            }
        }
    }
    
}
