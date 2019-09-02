//
//  DesignImageView.swift
//  FoodyPOS
//
//  Created by rajat on 26/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

///Rajat ji please update this. It is used in storyboard at two places. Rajat ji please update where it is used. I will update comments in other methods accordingly if required.
class DesignImageView: UIImageView {

     /**
    Draws the receiver’s image within the passed-in rectangle. Instantiate UIBezierPath class which is a predefined class 
    for creating a path that consists of straight and curved line segments that we can render in our custom views.
    Use method move which pre defined which moves the receiver’s current point to the specified location.
    Use method addLine which is pre defined which appends a straight line to the receiver’s path.
    Set line width to 0.5. Call method setStroke on bottomColor which is color object with grayscale and alpha values 
    that are both 0.0 and notify the system that your view’s contents need to be redrawn.
    Stroke method is called which is a pre defined method which draws a line along the receiver’s path using the current drawing properties.
    */
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
    Set bottomcolor to color object with grayscale and alpha values that are both 0.0 and notify the 
    system that your view’s contents need to be redrawn.
    */
    @IBInspectable var bottomColor:UIColor = UIColor.clear {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    ///Called when a designable object is created in Interface Builder. Call configure method
    override func prepareForInterfaceBuilder() {
        self.configure()
    }
    
    /**
    Prepares the receiver for service after it has been loaded from an Interface Builder archive, or nib file.
    Call configure method
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configure()
    }
    
    /**
    Variable for tint color. Call configure method
    */
    @IBInspectable override var tintColor: UIColor! {
        didSet {
            self.configure()
        }
    }
    
    /**
    Returns a new version of the image configured with the specified rendering mode. Set color to tint color.
    Set tint color to object with grayscale and alpha values that are both 0.0. Rajat ji please explain this
    if class is used.
    */
    private func configure() {
        self.image = self.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
         let color = super.tintColor
        super.tintColor = UIColor.clear
        super.tintColor = color
    }
}
