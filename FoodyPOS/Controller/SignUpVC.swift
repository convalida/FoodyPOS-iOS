//
//  SignUpVC.swift
//  FoodyPOS
//
//  Created by rajat on 28/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit
///Rajat ji, please update this, and also its use
protocol EmployeeDetailDelegate {
    ///Rajat ji, please update this, and also its use
    func showDetail(detail:[EmployeeDetail])
}

///View controller class for Add Employee
class SignUpVC: UIViewController {
    ///Outlet for name text field
    @IBOutlet weak var txtName: DesignTextField!
    ///Outlet for email text field
    @IBOutlet weak var txtEmail: DesignTextField!
    ///Outlet for password text field
    @IBOutlet weak var txtPassword: DesignTextField!
    ///Outlet for confirm password text field
    @IBOutlet weak var txtConfirmPassword: DesignTextField!
    ///Outlet for main view - complete screen. Rajat ji please check
    @IBOutlet weak var mainView: UIView!
    ///Outlet for add employee button
    @IBOutlet weak var btnAddEmployee: UIButton!
    ///Outlet for reset button
    @IBOutlet weak var btnReset: UIButton!
    ///Outlet for select button spinner for selecting role
    @IBOutlet weak var btnSelect: DesignButton!
    
    ///Structure for Employee Details instantiated
    var employeeDetails:[EmployeeDetail]?
    ///Rajat ji, please update this
    var delegate:EmployeeDetailDelegate!
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
  /**
     Life cycle method called after view is loaded. Set alignment of Add employee text button to centre. Remove the controller, on tap of view using UITapGestureRecognizer which is a pre defined class and call addGestureRecognizer which is a pre defined method.
     Add delegate of tap to self. Initalize hud view
 */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.btnAddEmployee.titleLabel?.textAlignment = .center
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
  Select spinner was clicked. Set style as actionSheet. Action sheet is used to present the user with a set of alternatives for how to proceed with a given task. If device is iPad, set style as alert. Set alert with app name, message and title
     */
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
    
    /**
     Add employee button clicked. Remove selction from all text fields. If none of the fields is empty, password is valid, password equals confirm password, call function callAddEmployeeAPI. If select spinner has value, Select, display Please select message in toast. If password not equal confirm password, display msgPasswordNotMatch from AppMessages in toast. If confirm password field is empty, display msgCnfrmPassRequired in AppMessages in toast. If password is not valid (from Validation.swift), display msgPasswordLength in AppMessages in toast. If password text field is empty, display msgPasswordRequired text in AppMessages in toast. If email text field is not valid (from Validation.swift) display msgValidEmail in AppMessages in toast. If after trimming characters, email text field is empty, display msgEmailRequired in AppMessages in toast. If after trimming characters, name text field is empty, display msgNameRequired in AppMessages in toast.
     */
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
    /**
 Reset button clicked. Set name text field, email text field, password text field, confirm password text field to empty, select cutton text to Select and remove highlight from name, email, password, confirm password text field.
     */
    @IBAction func btnResetDidClicked(_ sender: UIButton) {
        
        txtName.text = ""
        txtEmail.text = ""
        txtPassword.text = ""
        txtConfirmPassword.text = ""
        btnSelect.setTitle("Select", for: .normal)
        resignText()
    }
    
    //Close the pop-up
    /**
 When close button is clicked, remove the controller from super view.
     */
    @IBAction func btnCloseDidClicked(_ sender: UIButton) {
        removeController()
    }
    
    //MARK: ---------Other functions---------
    /**
On tap, controller is removed using UITapGestureRecognizer which is a pre defined class
     */
    @objc func hideOnTap(recognizer:UITapGestureRecognizer) {
        removeController()
    }
    
    
    /// Hide Keyboard
    /**
 Remove selection from name text field, email text field, password text field, confirm password text field and hide keyboard also. Rajat ji please check this
 */
    func resignText() {
        txtName.resignFirstResponder()
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
        txtConfirmPassword.resignFirstResponder()
    }
    
    /// Removes a controller from superview and parent view controller. After that, Rajat ji kindly update
    func removeController() {
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        if let detail = employeeDetails {
            delegate.showDetail(detail: detail)
        }
    }
    
    /**
 Call add employee api. Remove selection from all text  fields. If restaurant id is not equal to restaurant id in UserManager, return. Pass restaurant id and email from UserManager class, name, email address, role type and password from respective text fields. Display hud view. If api hit is successful and result code is 1, set employee details of the employee added to employee details in Employee section. Rajat ji please check this.
     Show message from response in toast and remove the controller. If result key in response is not 1, set value of message key to toast.If api hit is not successful, if error message is noDataMessage or noDataMessage1 in Constants.swift, display message msgFailed in AppMessages.swift in dialog else display error message in dialog.
     */
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
                } else {
                    self.showToast(employee.result.message)
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

extension SignUpVC:UIGestureRecognizerDelegate {
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
