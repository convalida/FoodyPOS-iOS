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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtEmail.text = "ravinandan.kumar@convalidatech.com"
        txtPassword.text = "welcome12#"
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
        let email = txtEmail.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let password = txtPassword.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if !(email.isEmpty) {
            if !(password.isEmpty) {
                if (email.isValidEmailId) {
                    if (password.isValidPassword) {
                        let parameterDic = ["email":email,
                                            "password":password] as [String:Any]
                        
//                        APIClient.login(paramters: parameterDic) { (result) in
//                            switch result {
//                            case .success(let user):
//                                if let result = user.result {
//                                    if result == 1 {
//                                        // UserManager.saveUserDataIntoDefaults(user: user)
                                        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.DashboardVC) as! DashboardVC
                                        self.navigationController?.pushViewController(vc, animated: true)
//                                    } else if let message = user.message {
//                                        DispatchQueue.main.async {
//                                            self.showToast(message)
//                                        }
//                                    }
//                                }
//
//                            case .failure(let error):
//                                print(error.localizedDescription)
//                            }
//                        }
                        
                    } else {
                        showToast(AppMessages.msgInvalidPassword)
                    }
                }else {
                    showToast(AppMessages.msgInvalidEmailPhone)
                }
            } else {
                showToast(AppMessages.msgPasswordRequired)
            }
        } else {
            showToast(AppMessages.msgEmailRequired)
        }
    }
    
    @IBAction func btnSignUpDidClicked(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.SignUpVC) as! SignUpVC
        self.view.addSubview(vc.view)
        self.addChildViewController(vc)
    }
}
