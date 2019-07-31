//
//  ForgotPasswordVC.swift
//  FoodyPOS
//
//  Created by rajat on 28/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

///View controller class for Forgot password dialog
class ForgotPasswordVC: UIViewController {

    ///Outlet for email text field
    @IBOutlet weak var txtEmail: DesignTextField!
    ///Outlet for main view- dialog view. Rajat ji please check
    @IBOutlet weak var mainView: UIView!
    
    ///Display status bar
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    ///Set light color of status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    ///Instantiate hud view
    var hudView = UIView()
    
    //MARK: ---------View Life Cycle---------
    
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
       // txtEmail.text = "ravinandan.kumar@convalidatech.com"
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    /// Dispose off any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

     ///Initialize the hud view and hide it by default
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
    /**
 Submit button clicked. Hide selection from email text field. If email field is empty and email is valid, call funtion callForgotPasswordAPI. If email id is not valid, display msgValidEmail from AppMessages in toast. If email id after trimming characters is empty, display msgEmailRequired from AppMessages in toast.
     */
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
    
    /**
 Login button (text) is clicked, remove the controller
     */
    @IBAction func btnLoginDidClicked(_ sender: UIButton) {
        removeController()
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
                } else {
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
