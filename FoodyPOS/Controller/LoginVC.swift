//
//  LoginVC.swift
//  FoodyPOS
//
//  Created by rajat on 28/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

///View controller class for login screen
class LoginVC: UIViewController {

    ///Outlet for email text field
    @IBOutlet weak var txtEmail: DesignTextField!
    ///Outlet for password text field
    @IBOutlet weak var txtPassword: DesignTextField!
    ///Outlet for Remember me checkbox
    @IBOutlet weak var btnChecked: UIButton!
    ///Outlet for navigation bar
    @IBOutlet weak var viewTop: UIView!
    
    //Check the remember status
    ///Set isRemember to false globally
    var isRemember = false
    ///Instantiate hud view
    var hudView = UIView()
    
    // Option to show hide status bar
    ///Display status bar
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    ///Set light color status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: ---------View Life Cycle---------
    /**
 Life cycle method called after view is loaded. Initialize hud view and set boolean value of is remember to true by default which will keep the remember me checkbox checked by default
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initHudView()
       // btnChecked.isSelected = true
        UserManager.isRemember=true
    }
/**
 Called before the view is loaded. If value of isRemember is true, then set check box to selected else set email and password text field to null.
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //txtEmail.text = "ravinandan.kumar@convalidatech.com"
        //txtPassword.text = "Ravi@123"
        
        //if user is checked "Remember Me" checkbox
        if UserManager.isRemember {
            isRemember = true
            btnChecked.isSelected = true
         /**   if let email = UserManager.email {
                txtEmail.text = email
            }
            if let password = UserManager.password {
                txtPassword.text = password
            }**/
        } else {
            txtEmail.text = ""
            txtPassword.text = ""
        }
    }
    
    /**
 Called when the view is about to disappear. Hide hud view
     */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hudView.isHidden = true
    }
    
    /// Dispose off any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    ///Initialize activity indicator or hud view
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
    
    /**
     Called when user clicks on Forgot Password button. Forgot password VC is added as sub view
  */
    @IBAction func btnForgotPasswordDidClicked(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.ForgotPasswordVC) as! ForgotPasswordVC
        self.view.addSubview(vc.view)
        self.addChildViewController(vc)

    }
    
    /**
     Toggle method for the RememberMe checkbox. If remember me check box is not selected, then set boolean value of isRemember to false else set boolean value of isRemeber to true.
     */
    @IBAction func btnCheckedDidClcked(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            isRemember = false
        }else {
            sender.isSelected = true
            isRemember = true
        }
    }
    
    /**
     On click of sign button, remove the highlight from a email text field and password text field selection, trim characters of email and password text field. If trimmed email text field and password has characters, check if email id and password is valid, pass paramaters email and password from respective text fields, device id from UserManager class, buildversion and Device type from AppDelegate class.
     Display hud view.
     Pass the parameters to APIClient class.
     If api hit is successful and result key in response is 1, set email, password and isRemember value in UserManager class, set isLogin to true in UserManager class, call saveUserDataIntoDefaults in UserManager class which saves data into UserDefaults. Instantiate DashboardVC.
     If result key in response is not 1, hide hud view, and set value of message key to toast. If api hit is not successful, if error message is noDataMessage or noDataMessage1 in Constants.swift, display message msgFailed in AppMessages.swift in dialog else display error message in dialog.
     If password is not valid, display msgPasswordLength in AppMessages in toast. If email id is not valid, then display msgValidEmail in AppMessages in toast. If password text field is empty, display msgPasswordRequired in AppMessages in toast. If email id text field is empty, display msgEmailRequired in AppMessages in toast.
 */
    @IBAction func btnSignInDidClicked(_ sender: UIButton) {
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
        let email = txtEmail.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let password = txtPassword.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
       
        //Validate all the field
        if !(email.isEmpty) {
            if !(password.isEmpty) {
                if (email.isValidEmailId) {
                    if (password.isValidPassword) {
                        let parameterDic = ["email":email,
                                            "password":password,
                                            "deviceId":UserManager.token ?? "",
                                            "buildversion":UIApplication.version ?? "",
                                            "DeviceType":UIApplication.appId ?? ""] as [String:Any]
                        hudView.isHidden = false
                        
                        //Call Login API
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
                                        //Launch Dashboard View Controller
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
                                if error.localizedDescription == noDataMessage || error.localizedDescription == noDataMessage1 {
                                    self.showAlert(title: kAppName, message: AppMessages.msgFailed)
                                } else {
                                    self.showAlert(title: kAppName, message: error.localizedDescription)
                                }
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
    
    //On click sign up button --> hidden
    ///This button is hidden and not used in project
    @IBAction func btnSignUpDidClicked(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.SignUpVC) as! SignUpVC
        self.view.addSubview(vc.view)
        self.addChildViewController(vc)
    }
}

