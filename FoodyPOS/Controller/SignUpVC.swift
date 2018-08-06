//
//  SignUpVC.swift
//  FoodyPOS
//
//  Created by rajat on 28/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    @IBOutlet weak var txtName: DesignTextField!
    @IBOutlet weak var txtEmail: DesignTextField!
    @IBOutlet weak var txtPassword: DesignTextField!
    @IBOutlet weak var txtConfirmPassword: DesignTextField!
    @IBOutlet weak var mainView: UIView!
    
    //MARK: ---------View Life Cycle---------
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
    
    //MARK: ---------Button actions---------

    @IBAction func btnSelectDidClicked(_ sender: UIButton) {
    }
    
    @IBAction func btnAddEmployeeDidClicked(_ sender: UIButton) {
    }
  
    @IBAction func btnResetDidClicked(_ sender: UIButton) {
    }
    
    //MARK: ---------Other functions---------
    @objc func hideOnTap(recognizer:UITapGestureRecognizer) {
        removeController()
    }
    
    func removeController() {
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
}

extension SignUpVC:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if self.mainView.frame.contains(touch.location(in: self.view)) {
            return false
        }
        return true
    }
}
