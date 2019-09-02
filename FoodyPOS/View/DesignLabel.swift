//
//  DesignLabel.swift
//  FoodyPOS
//
//  Created by rajat on 26/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

///Not used in project. Rajat ji please check this
class DesignLabel: UILabel {
    /**
    Overrides the default draw method of text field and set bottom color. Instantiate UIBezierPath class which is a predefined class 
    for creating a path that consists of straight and curved line segments that we can render in our custom views.
    Use method move which pre defined which moves the receiver’s current point to the specified location.
    Use method addLine which is pre defined which appends a straight line to the receiver’s path.
    Set line width to 0.5. Call method setStroke on bottomColor which is color object with grayscale and alpha values 
    that are both 0.0 and notify the system that your view’s contents need to be redrawn.
    Stroke method is called which is a pre defined method which draws a line along the receiver’s path using the current drawing properties.
    */
    override func draw(_ rect: CGRect) {
        // Drawing code
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
    Set bottom color to color object with grayscale and alpha values that are both 0.0 and notify the 
    system that your view’s contents need to be redrawn.
    */
    @IBInspectable var bottomColor:UIColor = UIColor.clear {
        didSet {
            self.setNeedsDisplay()
        }
    }
}
