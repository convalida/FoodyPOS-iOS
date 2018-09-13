//
//  ResetPasswordVC.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 23/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

class ResetPasswordVC: UIViewController {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var txtNewPassword: DesignTextField!
    @IBOutlet weak var txtConfirmPassword: DesignTextField!
    
    var otp:String!
    var hudView = UIView()
    
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
        
        initHudView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

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
                self.showAlert(title: kAppName, message: error.localizedDescription)
            }
        }
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

extension ResetPasswordVC:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if self.mainView.frame.contains(touch.location(in: self.view)) {
            return false
        }
        return true
    }
}
