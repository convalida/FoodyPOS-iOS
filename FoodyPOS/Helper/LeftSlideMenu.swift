//
//  LeftSlideMenu.swift
//  FoodyPOS
//
//  Created by rajat on 26/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import Foundation
import UIKit

open class LeftSlideMenu:UIViewController {
    
    open override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private var _mainVC:UIViewController!
    
    var menuWidth:CGFloat {
        if UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height {
            return UIScreen.main.bounds.size.height
        } else {
            return UIScreen.main.bounds.size.width * 0.80
        }
    }
    
    var isLeftMenuOpen:Bool = false
    
    var mainVC: UIViewController {
        get {
            return self._mainVC
        }
        set {
            self._mainVC = newValue
        }
    }
    
    @objc func updateUI(){
        self.menuVC.view.rectShadow(offsetWidth: 3, offsetHeight: 0, opacity: 0.5)
    }
    
    public convenience init(vc:UIViewController) {
        self.init()
        self.mainVC = vc
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    
    lazy var menuVC:UIViewController = {
        let Storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let viewController = Storyboard.instantiateViewController(withIdentifier: "LeftMenuVC") as! LeftMenuVC
        
        return viewController
    }()
    
    open func enableLeftEdgeGesture(){
        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(open))
        
        edgeGesture.edges = .left
        
        self.mainVC.view.addGestureRecognizer(edgeGesture)
    }
    
    lazy var menuGestureView:UIView = {
        
        //let menuWidth:CGFloat = UIScreen.main.bounds.size.width * 0.80
        
        //        let navbarHeight = self.navbar.frame.height
        
        let gestureView = UIView()
        
        gestureView.backgroundColor = UIColor.black
        
        gestureView.alpha = 0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(close))
        
        gestureView.addGestureRecognizer(tapGesture)
        
        return gestureView
        
    }()
    
    @objc open func open(){
        
        self.mainVC.presentedViewController?.dismiss(animated: false, completion: nil)
        
        //let navbarHeight = navbar.frame.height
        
        let frame = CGRect(x: -menuWidth, y: -20, width: menuWidth, height: self.mainVC.view.frame.height+20)
        //print(frame)
        
        if(!mainVC.childViewControllers.contains(menuVC)) {
            
            mainVC.addChildViewController(menuVC)
            
        }
        
        if(!self.mainVC.view.subviews.contains(self.menuGestureView)){
            self.mainVC.view.addSubview(self.menuGestureView)
            
            self.menuGestureView.translatesAutoresizingMaskIntoConstraints = false
            
            let bottomConstraint = NSLayoutConstraint(item: self.menuGestureView, attribute: .bottom, relatedBy: .equal, toItem: self.mainVC.view, attribute: .bottom, multiplier: 1, constant: 0)
            
            let topConstraint = NSLayoutConstraint(item: self.menuGestureView, attribute: .top, relatedBy: .equal, toItem: self.mainVC.view, attribute: .top, multiplier: 1, constant: 0)
            
            let leadingConstraint = NSLayoutConstraint(item: self.menuGestureView, attribute: .leading, relatedBy: .equal, toItem: self.mainVC.view, attribute: .leading, multiplier: 1, constant: 0)
            
            let trailingConstraint = NSLayoutConstraint(item: self.menuGestureView, attribute: .trailing, relatedBy: .equal, toItem: self.mainVC.view, attribute: .trailing, multiplier: 1, constant: 0)
            
            NSLayoutConstraint.activate([ leadingConstraint, trailingConstraint,bottomConstraint, topConstraint])
        }
        
        // Add Child View as Subview
        if(!self.mainVC.view.subviews.contains(menuVC.view)){
            
            self.mainVC.view.addSubview(menuVC.view)
            
            // Configure Child View
            menuVC.view.frame = frame
            
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.swipeLeftMenu))
            
            self.menuVC.view.addGestureRecognizer(panGesture)
            
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.closeLeftMenuOnSwipe))
            
            swipeGesture.direction = .left
            
            //swipeGesture.require(toFail: panGesture)
            
            self.menuVC.view.addGestureRecognizer(swipeGesture)
            
            self.menuVC.view.translatesAutoresizingMaskIntoConstraints = false
            
            let widthConstraint = NSLayoutConstraint(item: self.menuVC.view, attribute: .width, relatedBy: .equal,                                                 toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: menuWidth)
            
            let bottomConstraint = NSLayoutConstraint(item: self.menuVC.view, attribute: .bottom, relatedBy: .equal, toItem: self.mainVC.view, attribute: .bottom, multiplier: 1, constant: 0)
            
            let topConstraint = NSLayoutConstraint(item: self.menuVC.view, attribute: .top, relatedBy: .equal, toItem: self.mainVC.view, attribute: .top, multiplier: 1, constant: 0)
            
            let leadingConstraint = NSLayoutConstraint(item: self.menuVC.view, attribute: .leading, relatedBy: .equal, toItem: self.mainVC.view, attribute: .leading, multiplier: 1, constant: 0)
            
            NSLayoutConstraint.activate([widthConstraint, bottomConstraint,leadingConstraint,topConstraint])
            
            menuVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            menuVC.view.layoutIfNeeded()
            
        }
        
        // Notify Child View Controller
        //viewController.didMove(toParentViewController: self)
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.menuVC.view.frame.origin.x = 0
            
            UIView.animate(withDuration: 0.2, animations: {
                
                self.menuGestureView.alpha = 0.1
                
                self.updateUI()
                
            })
            
        })
    }
    
    @objc open func closeLeftMenuOnSwipe(gestureRecognizer:UISwipeGestureRecognizer){
        close()
    }
    
    @objc open func swipeLeftMenu(gestureRecognizer:UIPanGestureRecognizer){
        
        let translation = gestureRecognizer.translation(in: self.mainVC.view)
        
        guard let gestureView = gestureRecognizer.view else {
            
            return
            
        }
        
        if translation.x < 0 {
            
            gestureView.frame.origin.x = +translation.x
            
        }
        
        if gestureRecognizer.state == UIGestureRecognizerState.ended {
            
            if gestureView.frame.origin.x < -150 {
                
                close()
                
            } else {
                
                UIView.animate(withDuration: 0.3, animations: {
                    
                    self.menuVC.view.frame.origin.x = 0
                    
                })
                
            }
            
        }
        
    }
    
    @objc open func close(){
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.menuVC.view.frame.origin.x = -self.menuWidth
            
            self.isLeftMenuOpen = false
            
            self.menuGestureView.alpha = 0.0
            
        }) { finished in
            
            if finished {
                
                self.menuVC.view.removeFromSuperview()
                
                self.menuGestureView.removeFromSuperview()
                
            }
            
        }
        
    }
}

