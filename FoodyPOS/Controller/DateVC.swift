//
//  DateVC.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 21/11/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

///View controller class for date and time dialog called in CustomerDetailVC
class DateVC: UIViewController {

    ///Outlet for date button/text. Rajat ji please check if it is button or label
    @IBOutlet weak var btnDate: UIButton!
    ///Outlet for time button/text. Rajat ji please check if it is button or label
    @IBOutlet weak var btnTime: UIButton!
    ///Outlet for main view, i.e., complete dialog. Rajat ji please check
    @IBOutlet weak var mainView: UIView!
    
    ///Instantiate date variable to null
    var date = ""
    ///Instantiate time variable to null
    var time = ""
    
      ///Display status bar
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    ///Set light content of status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /**
    Life cycle method called after view is loaded. Remove the controller, on tap of view using UITapGestureRecognizer which is a pre defined class and call addGestureRecognizer which is a pre defined method.
     Add delegate of tap to self. Set title of date button and time button to date and time resp. passed in CustomerDetailVC. Rajat ji please check this.
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideOnTap(recognizer:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        self.btnDate.setTitle(date, for: .normal)
        self.btnTime.setTitle(time, for: .normal)
        
    }
    
    /**
    Called before the view is loaded. Set opacity of dialog background. (Area behind the alert dialog, covering the screen)
    */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    /**
    On tap, controller is removed by calling method removeController, using UITapGestureRecognizer which is a pre defined class
    */
    @objc func hideOnTap(recognizer:UITapGestureRecognizer) {
        removeController()
    }
    
    /**
    Unlink the view from its superview and its window, and removes it from the responder chain. Remove the view controller from its parent.
    */
    func removeController() {
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
}

extension DateVC:UIGestureRecognizerDelegate {
     /**
     To disable touch effect on alert dialog area
     */
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if self.mainView.frame.contains(touch.location(in: self.view)) {
            return false
        }
        return true
    }
}
