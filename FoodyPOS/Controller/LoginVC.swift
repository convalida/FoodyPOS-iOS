//
//  LoginVC.swift
//  FoodyPOS
//
//  Created by rajat on 28/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var txtEmail: DesignTextField!
    @IBOutlet weak var txtPassword: DesignTextField!
    @IBOutlet weak var btnChecked: UIButton!
    
    //MARK: ---------View Life Cycle---------
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: ---------Button actions---------

    @IBAction func btnForgotPasswordDidClicked(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.ForgotPasswordVC) as! ForgotPasswordVC
        self.view.addSubview(vc.view)
        self.addChildViewController(vc)

    }
    
    @IBAction func btnCheckedDidClcked(_ sender: UIButton) {
    }
    
    @IBAction func btnSignInDidClicked(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.DashboardVC) as! DashboardVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSignUpDidClicked(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.SignUpVC) as! SignUpVC
        self.view.addSubview(vc.view)
        self.addChildViewController(vc)
    }
}
