//
//  ForgotPasswordVC.swift
//  FoodyPOS
//
//  Created by rajat on 28/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var txtEmail: DesignTextField!
    @IBOutlet weak var mainView: UIView!
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var hudView = UIView()
    
    //MARK: ---------View Life Cycle---------
    
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
       // txtEmail.text = "ravinandan.kumar@convalidatech.com"
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
    
    //MARK: ---------Button actions---------
    @IBAction func btnSubmitDidClicked(_ sender: UIButton) {
        txtEmail.resignFirstResponder()
        let email = txtEmail.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if !(email.isEmpty) {
            if email.isValidEmailId {
               callForgotPasswordAPI()
            }else {
                showToast(AppMessages.msgValidEmail)
            }
        }else {
            showToast(AppMessages.msgEmailRequired)
        }
    }
    
    @IBAction func btnLoginDidClicked(_ sender: UIButton) {
        removeController()
    }

    //MARK: ---------Other functions---------
    @objc func hideOnTap(recognizer:UITapGestureRecognizer) {
        removeController()
    }
    
    func removeController() {
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    func callForgotPasswordAPI() {
        let parameter = ["EmailAddress":txtEmail.text!]
        
        hudView.isHidden = false
        APIClient.forgotPassword(paramters: parameter) { (result) in
            self.hudView.isHidden = true
            switch result {
            case .success(let data):
                if data.resultCode == "1" {
                    self.showToast(data.message)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.OtpVC) as! OtpVC
                    vc.email = self.txtEmail.text
                    self.navigationController?.pushViewController(vc, animated: true)
                    self.removeController()
                }else {
                    self.showToast(data.message)
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.showToast(AppMessages.msgFailed)
            }
        }
    }
}

extension ForgotPasswordVC:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if self.mainView.frame.contains(touch.location(in: self.view)) {
            return false
        }
        return true
    }
}
