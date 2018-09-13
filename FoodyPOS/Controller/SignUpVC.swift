//
//  SignUpVC.swift
//  FoodyPOS
//
//  Created by rajat on 28/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit
protocol EmployeeDetailDelegate {
    func showDetail(detail:[EmployeeDetail])
}

class SignUpVC: UIViewController {
    @IBOutlet weak var txtName: DesignTextField!
    @IBOutlet weak var txtEmail: DesignTextField!
    @IBOutlet weak var txtPassword: DesignTextField!
    @IBOutlet weak var txtConfirmPassword: DesignTextField!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var btnAddEmployee: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var btnSelect: DesignButton!
    
    var employeeDetails:[EmployeeDetail]?
    var delegate:EmployeeDetailDelegate!
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
    
    //Initiallize the hud view
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

    @IBAction func btnSelectDidClicked(_ sender: UIButton) {
        var style:UIAlertControllerStyle = .actionSheet
        if Global.isIpad {
            style = .alert
        }
        Alert.showDoubleButtonAlert(title: kAppName, message: "Choose an option", actionTitle1: "Employee", actionTitle2: "Manager", alertStyle: style, controller: self, handler1: {
            sender.setTitle("Employee", for: .normal)
        }) {
            sender.setTitle("Manager", for: .normal)
        }
    }
    
    //For add employee
    @IBAction func btnAddEmployeeDidClicked(_ sender: UIButton) {
        resignText()
        if !(txtName.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty)! {
            if !(txtEmail.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty)!{
                if (txtEmail.text?.isValidEmailId)! {
                    if !(txtPassword.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty)! {
                        if (txtPassword.text?.isValidPassword)! {
                            if !(txtConfirmPassword.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty)! {
                                if txtPassword.text == txtConfirmPassword.text {
                                    if btnSelect.titleLabel?.text != "Select" {
                                        callAddEmployeeAPI()
                                    }else {
                                        self.showToast("Please select the role")
                                    }
                                }else {
                                    self.showToast(AppMessages.msgPasswordNotMatch)
                                }
                            }else {
                                self.showToast(AppMessages.msgCnfrmPassRequired)
                            }
                        }else {
                            self.showToast(AppMessages.msgPasswordLength)
                        }
                    }else {
                        self.showToast(AppMessages.msgPasswordRequired)
                    }
                }else {
                    self.showToast(AppMessages.msgValidEmail)
                }
            }else {
                self.showToast(AppMessages.msgEmailRequired)
            }
        }else {
            self.showToast(AppMessages.msgNameRequired)
        }
    }
  
    //Reset all the field to blank
    @IBAction func btnResetDidClicked(_ sender: UIButton) {
        
        txtName.text = ""
        txtEmail.text = ""
        txtPassword.text = ""
        txtConfirmPassword.text = ""
        btnSelect.setTitle("Select", for: .normal)
        resignText()
    }
    
    //Close the pop-up
    @IBAction func btnCloseDidClicked(_ sender: UIButton) {
        removeController()
    }
    
    //MARK: ---------Other functions---------
    @objc func hideOnTap(recognizer:UITapGestureRecognizer) {
        removeController()
    }
    
    func resignText() {
        txtName.resignFirstResponder()
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
        txtConfirmPassword.resignFirstResponder()
    }
    
    func removeController() {
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        if let detail = employeeDetails {
            delegate.showDetail(detail: detail)
        }
    }
    
    func callAddEmployeeAPI() {
        resignText()
        guard let restaurentId = UserManager.restaurantID else {
            return
        }
        
        let prameterDic = ["RestaurantId":restaurentId,
                           "Name":txtName.text!,
                           "EmailAddresss":txtEmail.text!,
                           "RoleType":btnSelect.titleLabel!.text!,
                           "Password":txtPassword.text!,
                           "ModifiedBy":UserManager.email!]
        
        hudView.isHidden = false
        APIClient.addEmployee(paramters: prameterDic) { (result) in
            self.hudView.isHidden = true
            switch result {
            case .success(let employee):
                if employee.result.resultCode == "1" {
                    self.employeeDetails = employee.employeeDetails
                    self.showToast(employee.result.message)
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        self.removeController()
                    })
                }else {
                    self.showToast(employee.result.message)
                }
                
            case .failure(let error):
                self.showAlert(title: kAppName, message: error.localizedDescription)
            }
        }
    }
    
}

extension SignUpVC:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if self.mainView.frame.contains(touch.location(in: self.view)) {
            return false
        }
        return true
    }
}
