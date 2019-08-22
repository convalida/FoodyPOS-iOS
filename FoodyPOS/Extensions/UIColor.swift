//
//  UIColor.swift
//  FoodyPOS
//
//  Created by rajat on 28/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    /// Set theme color. Used throughout the project
    static var themeColor:UIColor {
        return UIColor(red: 1, green: 90/255, blue: 3/255, alpha: 1.0)
    }
    
    /// Get random color code. Not in use
    static var randomColor:UIColor {
        return UIColor(red: CGFloat(arc4random()) / CGFloat(UInt32.max), green: CGFloat(arc4random()) / CGFloat(UInt32.max), blue: CGFloat(arc4random()) / CGFloat(UInt32.max), alpha: 1.0)
    }
    
    /// Set border color
    static var borderColor:UIColor {
        return UIColor(red: 154/255, green: 154/255, blue: 154/255, alpha: 0.5)
    }
    
    /// Set light unselect color on sales report
    static var lightUnselect:UIColor {
        return UIColor(red: 184/255, green: 184/255, blue: 184/255, alpha: 0.5)
    }
}
