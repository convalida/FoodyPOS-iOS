//
//  DesignImageView.swift
//  FoodyPOS
//
//  Created by rajat on 26/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

///Rajat ji please update this. It is used in storyboard. Rajat ji please update where it is used. I will update comments accordingly.
class DesignImageView: UIImageView {

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
    
    @IBInspectable var bottomColor:UIColor = UIColor.clear {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func prepareForInterfaceBuilder() {
        self.configure()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configure()
    }
    
    @IBInspectable override var tintColor: UIColor! {
        didSet {
            self.configure()
        }
    }
    
    private func configure() {
        self.image = self.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
         let color = super.tintColor
        super.tintColor = UIColor.clear
        super.tintColor = color
    }
}
