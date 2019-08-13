//
//  OtpVC.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 22/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

///View controller class for OTP screen
class OtpVC: UIViewController {

    ///Outlet for email id text
    @IBOutlet weak var lblEmail: UILabel!
    ///Outlet for vertification code field.
    @IBOutlet weak var codeView: KWVerificationCodeView!
    ///Outlet for timer. Not used currently.
    @IBOutlet weak var lblTimer: UILabel!
    ///Outlet for verify button
    @IBOutlet weak var btnVerify: UIButton!
    ///Outlet for resend button
    @IBOutlet weak var btnResend: UIButton!
    ///Outlet for navigation bar.
    @IBOutlet weak var viewTop: UIView!

    ///Declare email string 
    var email:String!
    ///Instantiate timer
    var timer = Timer()
    ///Initlialize seconds value to 30
    var seconds = 30
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
    
    /**
    Life cycle method called after view is loaded. Set delegate of code view (verification code input field) to self. Initialize hud view.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        codeView.delegate = self
        // Do any additional setup after loading the view.
        initHudView()
    }

    /**
     Called before the view is loaded. Set email id passed from ForgotPasswordVC to email text field.
    Set timer text to 30 sec. This is not used currently. This is hidden in storyboard. Set verify button to be disabled by default and set alpha value to 0.5
    */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblEmail.text = email
        lblTimer.text = "30 s"
       // runTimer()
        btnVerify.isEnabled = false
        btnVerify.alpha = 0.5
    }
    
    ///Sent to the view controller when the app receives a memory warning.
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
        hudView.topAnchor.constraint(equalTo: viewTop.bottomAnchor).isActive = true
        hudView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        hudView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        hudView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        MBProgressHUD.showAdded(to: hudView, animated: true)
        
        hudView.isHidden = true
    }
    
    /**
     When back button is clicked, pop the top view controller from navigation stack and update the display.
     */
    @IBAction func btnBackDidClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /**
    Method called when submit button is clicked. Remove focus and keyboard from code view. If entered code (otp) is valid, call method callOtpAPI which hits otp web service
    else show toast Please enter otp
    */
    @IBAction func btnSubmitDidClicked(_ sender: UIButton) {
    codeView.resignFirstResponder()
        if codeView.hasValidCode() {
            callOtpAPI()
        } else {
            self.showToast("Please enter the otp")
        }
    }
    
    /**
    Method called when Resend Otp button is clicked. Set parameter email which is passed from ForgotPasswordVC.
    Display hud view. Pass parameter to forgotPassword method in APIClient classHide hud view. If api hit is successful, print message in reponse in logs, 
    and show toast message Verfication code sent to email id which is passed. If api hit is not successful, if error message is noDataMessage or noDataMessage1 in Constants.swift, display message msgFailed in AppMessages.swift in dialog else display error message in dialog.
    */
    @IBAction func btnResendDidClicked(_ sender: UIButton) {
        let parameter = ["EmailAddress":email!]
        
        self.hudView.isHidden = false
        APIClient.forgotPassword(paramters: parameter) { (result) in
            self.hudView.isHidden = true
            switch result {
            case .success(let data):
                print(data.message)
                self.showToast("Verification code sent to \(self.email!)")
                
            case .failure(let error):
                if error.localizedDescription == noDataMessage || error.localizedDescription == noDataMessage1 {
                    self.showAlert(title: kAppName, message: AppMessages.msgFailed)
                }else {
                    self.showAlert(title: kAppName, message: error.localizedDescription)
                }
            }
        }
    }
    
    ///Not used
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(OtpVC.updateTimer)), userInfo: nil, repeats: true)
    }
    
    ///Not used
    @objc func updateTimer() {
        seconds -= 1
        lblTimer.text = "\(seconds) s"
        if seconds == 0 {
            timer.invalidate()
        }
    }
    
    /**
    Method called when submit button is clicked after entering otp. Take parameter otp from code view if it exists and convert it to string
    and password as null. Hide hud view. If api hit is successful and result code is 1, instantiate ResetPasswordVC,
    get otp and pass it to vc and add view as sub view of view controller and add ResetPasswordVC as child view controller.
    If result code is not 1, show message in reponse as toast. If api hit is not successful, if error message is noDataMessage or noDataMessage1 in Constants.swift, display message msgFailed in AppMessages.swift in dialog else display error message in dialog.
    */
    private func callOtpAPI() {
        let parameter = ["Otp":codeView.getVerificationCode(),
                         "password":"null".replacingOccurrences(of: "\"", with: "")]
        
        self.hudView.isHidden = false
        APIClient.resetPassword(paramters: parameter) { (result) in
            self.hudView.isHidden = true
            switch result {
            case .success(let data):
                if data.resultCode == "1" {
                    //self.showToast(data.message)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.ResetPasswordVC) as! ResetPasswordVC
                    vc.otp = self.codeView.getVerificationCode()
                    self.view.addSubview(vc.view)
                    self.addChildViewController(vc)
                } else {
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

}

extension OtpVC:KWVerificationCodeViewDelegate {
/**
Notifies that the text in KWVerificationCodeView has been changed. This is especially useful in situations where you have to enable the submit button only if the verification code is valid. 
If entered verification code is valid, set verify button to enabled, its alpha value to 1, resend button as disabled and its alpha to 0.5,
else verify button to disabled, its alpha value to 0.5 and resend button to enabled and its alpha value to 1 
*/
    func didChangeVerificationCode() {
        if codeView.hasValidCode() {
            btnVerify.isEnabled = true
            btnVerify.alpha = 1.0
            btnResend.isEnabled = false
            btnResend.alpha = 0.5
        } else {
            btnVerify.isEnabled = false
            btnVerify.alpha = 0.5
            btnResend.isEnabled = true
            btnResend.alpha = 1.0
        }
    }
}
