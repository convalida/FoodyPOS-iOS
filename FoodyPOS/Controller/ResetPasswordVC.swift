//
//  ResetPasswordVC.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 23/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

/**
View controller class for ResetPassword dialog screen. 
*/
class ResetPasswordVC: UIViewController {
    ///Outlet for main view
    @IBOutlet weak var mainView: UIView!
    ///Outlet for new password text field
    @IBOutlet weak var txtNewPassword: DesignTextField!
    ///Outlet for confirm password text field
    @IBOutlet weak var txtConfirmPassword: DesignTextField!
    
    ///Declare otp string
    var otp:String!
    ///Instantiate hud view
    var hudView = UIView()
    
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
    Add delegate of tap to self. Initalize hud view
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideOnTap(recognizer:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        initHudView()
    }
    /**
    Called before the view is loaded. Set opacity of dialog background. (Area behind the alert dialog, covering the screen)
    */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    /// Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
    Initialize hud view. Set background color to white and hud view as sub view. Set constraints to top, left, bottom and right of hud view, add hud view and hide it.
    */
        func initHudView() {
        hudView.backgroundColor = UIColor.white
        self.view.addSubview(hudView)
        
        hudView.translatesAutoresizingMaskIntoConstraints = false
        hudView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        hudView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        hudView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        hudView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        MBProgressHUD.showAdded(to: hudView, animated: true)
        
        hudView.isHidden = true
    }
    
    /**
    Method called when Reset password button was clicked. Take password and confirm password from corresponding text fields and trim it.
    If password is not empty and is valid, confirm password is not empty and is valid and password and confirm password match, call method callResetPasswordAPI which hits the reset password web service.
    If password and confirmPassword do not match, display msgPasswordNotMatch from AppMessages in toast. If confirm password is not valid, display msgPasswordLength from AppMessages in toast.
    If confirm password is empty, display Please enter confirm password in toast. If password is not valid, display msgPasswordLength from AppMessages in toast.
    If password is empty, display Please enter new password in toast.
    */
    @IBAction func btnResetPasswordDidClicked(_ sender: UIButton) {
        let password = txtNewPassword.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let confPass = txtConfirmPassword.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if !(password.isEmpty) {
            if password.isValidPassword {
                if !(confPass.isEmpty) {
                    if confPass.isValidPassword {
                        if password == confPass {
                            callResetPasswordAPI()
                        }else {
                            self.showToast(AppMessages.msgPasswordNotMatch)
                        }
                    }else {
                        self.showToast(AppMessages.msgPasswordLength)
                    }
                }else {
                    self.showToast("Please enter the confirm password")
                }
            }else {
                self.showToast(AppMessages.msgPasswordLength)
            }
        } else {
             self.showToast("Please enter the new password")
        }
    }
    
    /**
    Method responsible for hitting web service when reset password button is tapped. Remove focus from password and confirm password text fields and hide keyboard.
    Take parameter Otp (passed from OtpVC) (Rajat ji please check this) and password from password text field. Display hud view. 
    Pass parameters to resetPassword method of APIClient class. Hide hud view. If api hit is successful, and result code is 1, pop the view controller.
    If result code is not 1, show message in response in toast. If api hit is not successful, if error message is noDataMessage or noDataMessage1 in Constants.swift, display message msgFailed in AppMessages.swift in dialog else display error message in dialog.
    */ 
    private func callResetPasswordAPI() {
        txtNewPassword.resignFirstResponder()
        txtConfirmPassword.resignFirstResponder()
        let parameter = ["Otp":otp!,
                         "password":txtNewPassword.text!]
        
        hudView.isHidden = false
        APIClient.resetPassword(paramters: parameter) { (result) in
            self.hudView.isHidden = true
            switch result {
            case .success(let data):
                if data.resultCode == "1" {
                    //self.showToast(data.message)
                        self.navigationController?.popToRootViewController(animated: true)
                }else {
                    self.showToast(data.message)
                }
            case .failure(let error):
                if error.localizedDescription == noDataMessage || error.localizedDescription == noDataMessage1 {
                    self.showAlert(title: kAppName, message: AppMessages.msgFailed)
                } else {
                    self.showAlert(title: kAppName, message: error.localizedDescription)
                }
            }
        }
    }
    
    //MARK: ---------Other functions---------
     /**
     On tap, controller is removed using UITapGestureRecognizer which is a pre defined class
     */
    @objc func hideOnTap(recognizer:UITapGestureRecognizer) {
        removeController()
    }
    
    /// Removes a controller from superview and parent view controller.
    func removeController() {
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
}

extension ResetPasswordVC:UIGestureRecognizerDelegate {
    /**
     To disable touch effect on alert dialog background area
     */
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if self.mainView.frame.contains(touch.location(in: self.view)) {
            return false
        }
        return true
    }
}
