//
//  ChangePasswordVC.swift
//  FoodyPOS
//
//  Created by rajat on 28/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var txtOldPass: DesignTextField!
    @IBOutlet weak var txtNewPass: DesignTextField!
    @IBOutlet weak var txtConfirmPass: DesignTextField!
    @IBOutlet weak var viewTop: UIView!

    var hudView = UIView()
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: ---------View Life Cycle---------

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initHudView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
                                    if error.localizedDescription == noDataMessage {
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
            self.showToast("Please enter the old password")
        }
    }
    
    @IBAction func btnBackDidClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
