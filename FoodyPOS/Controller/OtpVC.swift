//
//  OtpVC.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 22/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

class OtpVC: UIViewController {

    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var codeView: KWVerificationCodeView!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var btnVerify: UIButton!
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var viewTop: UIView!

    var email:String!
    var timer = Timer()
    var seconds = 30
    var hudView = UIView()
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        codeView.delegate = self
        // Do any additional setup after loading the view.
        initHudView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblEmail.text = email
        lblTimer.text = "30 s"
       // runTimer()
        btnVerify.isEnabled = false
        btnVerify.alpha = 0.5
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
    
    @IBAction func btnBackDidClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmitDidClicked(_ sender: UIButton) {
    codeView.resignFirstResponder()
        if codeView.hasValidCode() {
            callOtpAPI()
        }else {
            self.showToast("Please enter the otp")
        }
    }
    
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
                if error.localizedDescription == noDataMessage {
                    self.showAlert(title: kAppName, message: AppMessages.msgFailed)
                }else {
                    self.showAlert(title: kAppName, message: error.localizedDescription)
                }
            }
        }
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(OtpVC.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds -= 1
        lblTimer.text = "\(seconds) s"
        if seconds == 0 {
            timer.invalidate()
        }
    }
    
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
    }

}

extension OtpVC:KWVerificationCodeViewDelegate {
    func didChangeVerificationCode() {
        if codeView.hasValidCode() {
            btnVerify.isEnabled = true
            btnVerify.alpha = 1.0
            btnResend.isEnabled = false
            btnResend.alpha = 0.5
        }else {
            btnVerify.isEnabled = false
            btnVerify.alpha = 0.5
            btnResend.isEnabled = true
            btnResend.alpha = 1.0
        }
    }
}
