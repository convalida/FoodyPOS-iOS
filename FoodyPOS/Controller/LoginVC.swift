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
    @IBOutlet weak var viewTop: UIView!
    
    //Check the remember status
    var isRemember = false
    var hudView = UIView()
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    //set light color status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: ---------View Life Cycle---------
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initHudView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //txtEmail.text = "ravinandan.kumar@convalidatech.com"
        //txtPassword.text = "Ravi@123"
        
        //if user is checked "Remember Me" checkbox
        if UserManager.isRemember {
            isRemember = true
            btnChecked.isSelected = true
            if let email = UserManager.email {
                txtEmail.text = email
            }
            if let password = UserManager.password {
                txtPassword.text = password
            }
        }else {
            txtEmail.text = ""
            txtPassword.text = ""
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //initialize activity indicator
    func initHudView() {
        hudView.backgroundColor = UIColor.white
        self.view.addSubview(hudView)
        
        hudView.translatesAutoresizingMaskIntoConstraints = false
        hudView.topAnchor.constraint(equalTo: viewTop.bottomAnchor).isActive = true
        hudView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        hudView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        hudView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        MBProgressHUD.showAdded(to: hudView, animated: true)
        
        hudView.isHidden = true
    }
    
    //MARK: ---------Button actions---------
    @IBAction func btnForgotPasswordDidClicked(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.ForgotPasswordVC) as! ForgotPasswordVC
        self.view.addSubview(vc.view)
        self.addChildViewController(vc)

    }
    
    /// Check already login or not
    ///
    /// - Parameter sender: button
    @IBAction func btnCheckedDidClcked(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            isRemember = false
        }else {
            sender.isSelected = true
            isRemember = true
        }
    }
    
    @IBAction func btnSignInDidClicked(_ sender: UIButton) {
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
        let email = txtEmail.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let password = txtPassword.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if !(email.isEmpty) {
            if !(password.isEmpty) {
                if (email.isValidEmailId) {
                    if (password.isValidPassword) {
                        let parameterDic = ["email":email,
                                            "password":password] as [String:Any]
                        hudView.isHidden = false
                        APIClient.login(paramters: parameterDic) { (result) in
                            switch result {
                            case .success(let user):
                                if let result = user.result {
                                    if result == "1" {
                                        UserManager.email = self.txtEmail.text
                                        UserManager.password = self.txtPassword.text
                                        UserManager.isRemember = self.isRemember
                                        UserManager.isLogin = true
                                        UserManager.saveUserDataIntoDefaults(user: user)
                                        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.DashboardVC) as! DashboardVC
                                            self.navigationController?.pushViewController(vc, animated: true)
                                    } else if let message = user.message {
                                        self.hudView.isHidden = true
                                        DispatchQueue.main.async {
                                            self.showToast(message)
                                        }
                                    }
                                }

                            case .failure(let error):
                                self.hudView.isHidden = true
                                print(error.localizedDescription)
                                self.showToast(AppMessages.msgFailed)
                            }
                        }
                    } else {
                        showToast(AppMessages.msgPasswordLength)
                    }
                }else {
                    showToast(AppMessages.msgValidEmail)
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
