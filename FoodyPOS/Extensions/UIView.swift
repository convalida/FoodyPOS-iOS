//
//  UiView.swift
//  SwiftAmplifier
//
//  Created by Rajat Jain on 15/06/17.
//  Copyright © 2017 rajatjain4061. All rights reserved.
//  Fork this repo on Github: https://github.com/rajatjain4061/SwiftAmplifier
//

import Foundation
import UIKit

///Enum for border. Not in Use
enum ViewBorder: String {
    ///For left border of UIView
    case left
    ///For right border of UIView
    case right
    ///For top border of UIView
    case top
    ///For bottom border of UIView
    case bottom
}

extension UIView {
    
    /// Create editable corner radius of a view. This is used on all popup, buttons to make rouned corners
    @IBInspectable var cornerRadii:CGFloat {
        set {
            self.layer.cornerRadius = newValue
        }
        get {
            return self.layer.cornerRadius
        }
    }
    
    /// Create editable border color of a view. This is used on date selector fields
    @IBInspectable var borderColor:UIColor {
        set {
            self.layer.borderColor = newValue.cgColor
        }
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
    }
    
    /// Create editable border width of a view. This is used on date selector fields
    @IBInspectable var borderWidth:CGFloat {
        set {
            self.layer.borderWidth = newValue
        }
        get {
            return self.layer.borderWidth
        }
    }
    
    /** Create editable shadow of a view. This is mainly used for bottom shadow on top navigation bar and 
    some other buttons. This applies to all UIView so top navigation and buttons have this property on storyboard.
    */
    @IBInspectable
    public var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    /// Create editable shadow offset of a view. This is mainly used with bottom shadow on Navigation bar and some other buttons
    
    @IBInspectable
    public var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    /// Create editable shadow opacity of a view. This is mainly used with bottom shadow on Navigation bar and some other buttons
    @IBInspectable
    public var shadowOpacity: Double {
        get {
            return Double(layer.shadowOpacity)
        }
        set {
            layer.shadowOpacity = Float(newValue)
        }
    }
    
    /// Create editable shadow radius of a view. This is mainly used with bottom shadow on Navigation bar and some other buttons
    @IBInspectable
    public var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    /// Create editable shadow path of a view. Used in rectShadow method
    @IBInspectable
    public var shadowPath: CGPath? {
        get {
            return layer.shadowPath
        }
        set {
            layer.shadowPath = newValue
        }
    }
    
    /// Create editable shadow raster property of a view. Not used
    @IBInspectable
    public var shadowShouldRasterize: Bool {
        get {
            return layer.shouldRasterize
        }
        set {
            layer.shouldRasterize = newValue
        }
    }
    
    /// Create editable rasterizationScale of a view. Not used
    @IBInspectable
    public var shadowRasterizationScale: CGFloat {
        get {
            return layer.rasterizationScale
        }
        set {
            layer.rasterizationScale = newValue
        }
    }
    
    /// Create editable maskToBounds of a view. This is mainly used with bottom shadow on Navigation bar and some other buttons 
    @IBInspectable
    public var maskToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
    
    /// Applies a rectangular shadow of a view. Used in LeftSlideMenu.
    func rectShadow(offsetWidth:CGFloat = -1,offsetHeight:CGFloat = 1,opacity:Float = 0.5,radius:CGFloat = 1,color: CGColor = UIColor.black.cgColor) {
        
        self.layer.masksToBounds = false
        
        self.layer.shadowColor = UIColor.black.cgColor
        
        self.layer.shadowOpacity = opacity
        
        self.layer.shadowOffset = CGSize(width: offsetWidth, height: offsetHeight)
        
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        
        self.layer.shouldRasterize = true
        
        self.layer.rasterizationScale = UIScreen.main.scale
        
    }
}
