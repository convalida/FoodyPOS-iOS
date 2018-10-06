//
//  EditEmployeeVC.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 05/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

protocol EditEmployeeDelegate {
    func updateEmployee()
}

class EditEmployeeVC: UIViewController {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblEmailId: UILabel!
    @IBOutlet weak var lblRoleType: UIButton!
    @IBOutlet weak var btnActive: UIButton!
    
    var employeeDetail:EmployeeDetail?
    var delegate:EditEmployeeDelegate!
    var isUpdate = false
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
        
        if let employeeDetail = employeeDetail {
            lblUserName.text = employeeDetail.username
            lblEmailId.text = employeeDetail.emailID
            lblRoleType.setTitle(employeeDetail.roleType, for: .normal)
            
            if employeeDetail.active == "True" {
                btnActive.isSelected = true
            }
        }
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
    
    @IBAction func btnStatusDidClicked(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        }else {
            sender.isSelected = true
        }
    }
    
    @IBAction func btnUpdateDidClicked(_ sender: UIButton) {
        guard let restaurentId = UserManager.restaurantID, let employee = employeeDetail else {
            return
        }
        var isActive = "True"
        if !btnActive.isSelected {
            isActive = "False"
        }
        let prameterDic = ["RestaurantId":restaurentId,
                           "AccountId":employee.accountID,
                           "Role":lblRoleType.titleLabel!.text!,
                           "Active":isActive,
                           "ModifiedBy":UserManager.email!]
        
        hudView.isHidden = false
        APIClient.updateEmployee(paramters: prameterDic) { (result) in
            self.hudView.isHidden = true
            switch result {
            case .success(let result):
                if result.resultCode == "1" {
                    self.showToast(result.message)
                    self.isUpdate = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        /// Hide Employee Form
                        self.removeController()
                    })
                }else {
                    self.showToast(result.message)
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
    
    /// Calls when user click on cancel button
    @IBAction func btnCancelDidClicked(_ sender: UIButton) {
        removeController()
    }
    
    /// Show option to choose Role
    @IBAction func btnRoleTypeDidClicked(_ sender: UIButton) {
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
    
    /// Remove controller when user clicks on any other part of screen
    @objc func hideOnTap(recognizer:UITapGestureRecognizer) {
        removeController()
    }
    
    func removeController() {
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        if isUpdate {
            delegate.updateEmployee()
        }
    }
}

extension EditEmployeeVC:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if self.mainView.frame.contains(touch.location(in: self.view)) {
            return false
        }
        return true
    }
}
