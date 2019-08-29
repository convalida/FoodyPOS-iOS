//
//  LeftSlideMenu.swift
//  FoodyPOS
//
//  Created by rajat on 26/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import Foundation
import UIKit

///Class for Left slide menu on dashboard
open class LeftSlideMenu:UIViewController {
    
    ///Display status bar
    open override var prefersStatusBarHidden: Bool {
        return true
    }
    
    ///Stores reference of ViewController on which the menu is called. It can be any view controller which is set while initializing the LeftMenu
    private var _mainVC:UIViewController!

   /**
   If device width is greater than height of device (in case of landscape mode), return width of menu equal to height of screen,
   else (in case of portrait mode), set width of menu equal to 0.8 times width of screen.
   */ 
    var menuWidth:CGFloat {
        if UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height {
            return UIScreen.main.bounds.size.height
        } else {
            return UIScreen.main.bounds.size.width * 0.80
        }
    }
    
    ///Set left menu to be closed by default
    var isLeftMenuOpen:Bool = false
    
    ///Getter and Setter method to get reference of ViewController on which the menu is called
    var mainVC: UIViewController {
        get {
            return self._mainVC
        }
        set {
            self._mainVC = newValue
        }
    }

   /**
   This method is used to apply a rectangular shadow of a view. This shadow is displayed at right edge of left slide menu.
   */ 
    @objc func updateUI(){
        self.menuVC.view.rectShadow(offsetWidth: 3, offsetHeight: 0, opacity: 0.5)
    }
    
    /**
    This is called when we initialize the LeftMenu on any controller. Initialize LeftMenu. Set its vc to 
    mainvc which dashboardvc in this case. If orientation is changed, post a notification which calls updateUI method which shows
    shadow in left menu accordingly.
    */
    public convenience init(vc:UIViewController) {
        self.init()
        self.mainVC = vc
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
   /**
   Instantiate LeftMenuVC in Main.storyboard and return that vc.
   */
    lazy var menuVC:UIViewController = {
        let Storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let viewController = Storyboard.instantiateViewController(withIdentifier: "LeftMenuVC") as! LeftMenuVC
        
        return viewController
    }()
    
    /**
    Create a new Edge Gesture Recognizer that looks for panning (dragging) gestures that start near an edge of the screen
     and add it to main view of self.mainVC. Specify that from left edge the gesture may start. Called in DashboardVC
    */
    open func enableLeftEdgeGesture(){
        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(open))
        
        edgeGesture.edges = .left
        
        self.mainVC.view.addGestureRecognizer(edgeGesture)
    }
    
    /**
    This refers to the remaining part of the screen where the menu is not shown but a black transparent 
    background is added. When user taps on this gesture, it closes the menu. This method is called in this class only.
    On tap gesture, menu is closed and view is returned.
    */
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
    
    /**
    This method is called in DashboardVC when menu button is clicked.
    Dismiss the presented view controller.
    Set dimensions of frame and set frame of self.menuVC.view.frame. Frame dimensions are set only in case it is open. Minakshi ji, negative coordinates is to shift 20px from top.
    If mainVC's child view controller does not has menuVC, then add menu vc as child view controller of main vc.
    Add menuGestureView so that user can click anywhere on the screen and the menu will be closed.
    View’s autoresizing mask is not translated into Auto Layout constraints. Add top, bottom, leading and trailing constraints to menuGestureVC 
    If mainvc's sub view does not has menuvc, add menuvc as sub view of mainvc. Add frame to view of menuvc .
    Add pan gesture recognizer that looks for panning (dragging) gestures calling method swipeLeftMenu.
    Add swipe gesture recognizer that looks for swipe gestures calling method closeLeftMenuOnSwipe.
    Set swipe direction to left and add gesture to menuvc
    Set width, bottom, top and leading constraint, to menuVC (LeftMenuVC)
    Set auto resizing mask (determines how the receiver resizes itself when its superview’s bounds change) to flexible width and flexible height
    Lay out the subviews immediately, if layout updates are pending.
    Set animation to Left menu portion with frame's origin from x=0 and other remaining portion with alpha value 0.1.
     Call updateUI method, which displays shadow in edge of left slide menu.
    */
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
    
    /**
    This method is called on swipe gesture recognizer to close left slide menu. Call method close.
    */
    @objc open func closeLeftMenuOnSwipe(gestureRecognizer:UISwipeGestureRecognizer){
        close()
    }
    
    /**
    This method is called for pan gesture. It is used to close and open the menu on when user starts to swipe the menu in left or right 
    direction. If gesture recognizer view is null, then return. 
    If translation is negative, (i.e. left menu is closed), then set origin of frame to positive value of translation.
    If gesture recognizer state is ended, i.e., it is completely opened or closed currently, if origin of frame of gesture recognizer is negative, 
    then close() method is called to close the menu. Rajat ji please check this and mention if negative value of gesture means menu is open.  
    Else animate the menu and set frame's origin to 0 of x axis. M ji please mention if frame's orgin 0 means the menu is open or closed.

   
   
    */
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
    
    /**
    This method is called in closeLeftMenuOnSwipe. This method animates the left menu until the frame width
    is set to 0. Set origin of menuvc frame to negative of width of menu, set isLeftMenuOpen value to false,
    set alpha value of menuGestureView to 0. When animation is completed, unlink menuVC and menuGestureView from 
    superview and its window, and remove it from the responder chain.
    */
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

