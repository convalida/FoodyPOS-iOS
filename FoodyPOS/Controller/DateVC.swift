//
//  DateVC.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 21/11/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

class DateVC: UIViewController {

    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var btnTime: UIButton!
    @IBOutlet weak var mainView: UIView!
    
    var date = ""
    var time = ""
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideOnTap(recognizer:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        self.btnDate.setTitle(date, for: .normal)
        self.btnTime.setTitle(time, for: .normal)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    @objc func hideOnTap(recognizer:UITapGestureRecognizer) {
        removeController()
    }
    
    func removeController() {
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
}

extension DateVC:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if self.mainView.frame.contains(touch.location(in: self.view)) {
            return false
        }
        return true
    }
}
