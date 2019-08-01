//
//  ChangePasswordVC.swift
//  FoodyPOS
//
//  Created by rajat on 28/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

///View controller for change password class
class ChangePasswordVC: UIViewController {

    ///Outlet for old password text field
    @IBOutlet weak var txtOldPass: DesignTextField!
    ///Outlet for new password text field
    @IBOutlet weak var txtNewPass: DesignTextField!
    ///Outlet for confirm password text field
    @IBOutlet weak var txtConfirmPass: DesignTextField!
    ///Outlet for action bar view
    @IBOutlet weak var viewTop: UIView!

    ///Instantiate hud view
    var hudView = UIView()
    
    ///Display status bar
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    ///Set light color of status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: ---------View Life Cycle---------

    ///Life cycle method called after view is loaded. Initialize hud view
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initHudView()
    }

    /// Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///Initialize hud view with background color white, set constraints and add hud view. Hide hud view
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
 Submit button clicked. Remove highlight from old password, new password and confirm password text field. Trim characters in old password, new password and confirm password text field. If old password, new password and confirm password is empty, if new password is valid password and new password equals confirm password, if UserManager class does not have email address, then return. Take parameters, display hud view, pass parameters to APIClient class, hide hud view. If api hit is successful, and result code is 1. If isRemember value in UserManager class is true, call flusUserDefaults value in Global class which which removes user default data and display root view controller, show LoginVC. If isRemember value in UserManager class is false, call flusUserDefaults value in Global class which which removes user default data and pop all view controllers in stack except root view controller (LoginVC). If result code is not 1, show mwssage from response in toast. If api hit is not successful, if error message is noDataMessage or noDataMessage1 in Constants.swift, display message msgFailed in AppMessages.swift in dialog else display error message in dialog. If new password and confirm passwords do not match, display msgPasswordNotMatch from AppMessages in toast. If confirm password field is empty, display Please enter the confirm password in toast. If new password is not valid (from Validation.swift), display msgPasswordLength from AppMessages in toast. If new password is empty, display Please enter the new password in toast. If old password text field is empty, display Please enter the old password in toast
     */
    @IBAction func btnSubmitDidClicked(_ sender: UIButton) {
        txtOldPass.resignFirstResponder()
        txtNewPass.resignFirstResponder()
        txtConfirmPass.resignFirstResponder()
        let oldPass = txtOldPass.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let newPass = txtNewPass.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let confirmPass = txtConfirmPass.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if !(oldPass.isEmpty) {
            if !(newPass.isEmpty) {
                if newPass.isValidPassword {
                    if !(confirmPass.isEmpty) {
                        if newPass == confirmPass {
                            guard let email = UserManager.email else {
                                return
                            }
                            let parameter = ["EmailAddresss":email,
                                             "OldPassword":oldPass,
                                             "NewPassword":newPass]
                            self.hudView.isHidden = false
                            APIClient.changePassword(paramters: parameter) { (result) in
                                self.hudView.isHidden = true
                                switch result {
                                case .success(let data):
                                    if data.resultCode == "1" {
                                      //  self.showToast(data.message)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                                            if UserManager.isRemember {
                                                Global.flushUserDefaults()
                                                Global.showRootView(withIdentifier: StoryboardConstant.LoginVC)
                                            }else {
                                                Global.flushUserDefaults()
                                                self.navigationController?.popToRootViewController(animated: true)
                                            }
                                        })
                                    }else {
                                     self.showToast(data.message)
                                    }
                                case .failure(let error):
                                    if error.localizedDescription == noDataMessage || error.localizedDescription == noDataMessage1 {
                                        self.showAlert(title: kAppName, message: AppMessages.msgFailed)
                                    }else {
                                        self.showAlert(title: kAppName, message: error.localizedDescription)
                                    }
                                }
                            }
                        }else {
                            self.showToast(AppMessages.msgPasswordNotMatch)
                        }
                    }else {
                        self.showToast("Please enter the confirm password")
                    }
                }else {
                    self.showToast(AppMessages.msgPasswordLength)
                }
            }else {
                self.showToast("Please enter the new password")
            }
        }else {
            self.showToast ("Please enter the old password")
        }
    }
    
    ///Back button clicked. Pop the top view controller from stack
    @IBAction func btnBackDidClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
