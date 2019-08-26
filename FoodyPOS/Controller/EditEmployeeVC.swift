//
//  EditEmployeeVC.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 05/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

///Protocol for defining delegate of current class. This is used to update the employee details in EmployeeDetailVC.
protocol EditEmployeeDelegate {
    ///Abstract method for EditEmployeeDelegate protocol.
    func updateEmployee()
}

/**
View controller class for Edit employee dialog
*/
class EditEmployeeVC: UIViewController {
    ///Outlet for main view/ complete dialog.
    @IBOutlet weak var mainView: UIView!
    ///Outlet for user name label
    @IBOutlet weak var lblUserName: UILabel!
    ///Outlet for email id label
    @IBOutlet weak var lblEmailId: UILabel!
    ///Outlet for role type button.
    @IBOutlet weak var lblRoleType: UIButton!
    ///Outlet for active status button/check box.
    @IBOutlet weak var btnActive: UIButton!
    
    ///Declare variable for EmployeeDetail strucutre
    var employeeDetail:EmployeeDetail?
    ///Set delegate of EditEmployeeVC to EditEmployeeDelegate.
    var delegate:EditEmployeeDelegate!
    ///Set boolean isUpdate to false
    var isUpdate = false
    ///Instantiate hud view
    var hudView = UIView()
    
     ///Set status bar to visible 
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    ///Set light content of status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /**
    Life cycle method called after view is loaded. Remove the controller, on tap of view using UITapGestureRecognizer which is a pre defined class and call addGestureRecognizer which is a pre defined method.
     Add delegate of tap to self. Initalize hud view.
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
    Called before the view is loaded. Force the view to update its layout immediately. If no layout updates are pending, this method exits without modifying the layout or calling any layout-related callbacks.
    Set opacity of dialog background. (Area behind the alert dialog, covering the screen). If employeeDetail is not null,
    Set employee's user name, email id to corresponding text fields and role type to title of correponding field
    If active value in employeeDetail is true, set btnActive to selected.
    */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
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
        hudView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        hudView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        hudView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        hudView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        MBProgressHUD.showAdded(to: hudView, animated: true)
        
        hudView.isHidden = true
    }
    
    /**
    Method called when status button (check box) is clicked to toggle its selected value. If button is selected or isSelected value is true previously,
    then set it to unselected or isSelected value to false. If button is not selected or isSelected value is false previously, then set it to selected or isSelected value to true.
    */
    @IBAction func btnStatusDidClicked(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        }else {
            sender.isSelected = true
        }
    }
    
    /**
    Method called when update button is clicked. If UserManager class does not have restaurant id or employeeDetail is null then return.
    Set isActive variable to true. If btnActive is not selected, set isActive value to false. Take parameters restaurant id from UserManager class,
    account id from employee, role type from lblRoleType, isActive value is initalized locally, modifiedBy value from UserManager class's emailvalue.
    Display hud view. Call updateEmployee method from APIClient class and pass parameters to it. If api hit is successful and resultCode is 1, 
    show message in response in toast, set isUpdate value to true. Call method removeController which removes the controller or hide employee form.
    If result code is not 1, show the message in response in toast. If api hit is not successful, if error message is noDataMessage or noDataMessage1 in Constants.swift, display message msgFailed in AppMessages.swift in dialog else display error message in dialog.
    */
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
    
    /** 
    Method called when user clicked on cancel button. Call method removeController which removes the controller.
    */
    @IBAction func btnCancelDidClicked(_ sender: UIButton) {
        removeController()
    }
    
    // Show option to choose Role
    /**
    Method called when role type button. Set style to action sheet to present the user with a set of alternatives for role type.
    If device is iPad, set style to alert. Set alert with two buttons with message Choose an option, actions - Employee, Manager in both cases - iPhone and iPad. Rajat ji please check this 
    */
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
    
    /// Remove controller when user clicks on any other part of screen by calling method removeCOntroller
    @objc func hideOnTap(recognizer:UITapGestureRecognizer) {
        removeController()
    }
    
    /**
    Method called when update button is clicked, cancel button is clicked or user touched outside the alert.
    Unlink the view from its superview and its window, and removes it from the responder chain. Remove the view controller from its parent.
    If isUpdate value is true (after successful api hit), then call updateEmployee method which hits the Edit employee web service.
    */
    func removeController() {
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        if isUpdate {
            delegate.updateEmployee()
        }
    }
}

extension EditEmployeeVC:UIGestureRecognizerDelegate {
     /**
     To disable touch effect on alert dialog area
     */
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if self.mainView.frame.contains(touch.location(in: self.view)) {
            return false
        }
        return true
    }
}
