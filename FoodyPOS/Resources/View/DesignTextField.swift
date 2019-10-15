//
//  DesignTextField.swift
//  FoodyPOS
//
//  Created by rajat on 26/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//
//  Used External Library

import UIKit

//@IBDesignable
/**
Class for creating input text field. Used in  ChangePasswordVC, ForgotPasswordVC, LoginVC, ResetPasswordVC, SignUpVC.
*/
class DesignTextField: UITextField {
    
    /// Overrides the default draw method of text field and set bottom color
    override func draw(_ rect: CGRect) {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: self.bounds.origin.x, y: self.bounds.height
            - 0.5))
        path.addLine(to: CGPoint(x: self.bounds.size.width, y: self.bounds.height
            - 0.5))
        path.lineWidth = 0.5
        self.bottomColor.setStroke()
        path.stroke()
       
    }
    
    /**
    Returns the drawing rectangle of the receiver’s left overlay view. Padding is added to origin. This is not in use
    */
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += padding
        return textRect
    }
    
    /**
    Returns the drawing location of the receiver’s right overlay view. Padding is subtracted from origin. This is not in use
    */
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= padding
        return textRect
    }
    
    /// Sets TextField placeholder color to gray
    @IBInspectable var placeHolderColor: UIColor = UIColor.gray {
        didSet {
             self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: placeHolderColor])
        }
    }
    
    /** 
    Sets TextField bottom color to grayscale and alpha values that are both 0.0. Set bezel style border and mark the receiver’s entire bounds rectangle as needing to be redrawn, .bezel displays a bezel-style border for the text field. This style is typically used for standard data-entry fields. Bottom color of text field as theme color is set in storybaord
    */
    @IBInspectable var bottomColor:UIColor = UIColor.clear {
        didSet {
            self.borderStyle = .bezel
            self.setNeedsDisplay()
        }
    }
    
    /// Sets TextField padding
    @IBInspectable var padding:CGFloat = 0
    
    /**
     Sets image of a TextField at 0,0 with height and width 20 each. If image is not null, set right overlay view to always appear in the text field.
    If image is null, set left overlay view to never appear in the  text field. This is not in use
    */
    @IBInspectable var image:UIImage? {
        didSet {
            if let img = image {
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height:20 ))
                imageView.image = img
                rightViewMode = .always
                rightView = imageView
            } else {
                leftViewMode = .never
                leftView = nil
            }
        }
    }
}

///Variable for max length of input text field initialized.
private var kAssociationKeyMaxLength: Int = 0

extension UITextField {
    
    /**
    Getter  and setter for max. length of text field. If length is not null, then return length, else return maximum value. This is used for password max length to 15 in storyboard
    */
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    /**
    Method to check length of input in text field. Not used in project
    */
    @objc func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text,
            prospectiveText.count > maxLength
            else {
                return
        }
        
        let selection = selectedTextRange
        let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        text = prospectiveText.substring(to: maxCharIndex)
        selectedTextRange = selection
    }
}

