//
//  EditEmployeeVC.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 05/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

class EditEmployeeVC: UIViewController {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblEmailId: UILabel!
    @IBOutlet weak var lblRoleType: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideOnTap(recognizer:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnStatusDidClicked(_ sender: UIButton) {
    }
    
    @IBAction func btnUpdateDidClicked(_ sender: UIButton) {
    }
    
    
    @IBAction func btnCancelDidClicked(_ sender: UIButton) {
    }
    
    @objc func hideOnTap(recognizer:UITapGestureRecognizer) {
        removeController()
    }
    
    func removeController() {
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
}

extension EditEmployeeVC:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if self.mainView.frame.contains(touch.location(in: self.view)) {
            return false
        }
        return true
    }
}
