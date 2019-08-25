//
//  EmployeeDetailVC.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 04/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

/**
View controller class for Employee Details
*/
class EmployeeDetailVC: UIViewController {
    ///Outlet for table view
    @IBOutlet weak var tableView: UITableView!
    ///Outlet for navigation bar
    @IBOutlet weak var viewTop: UIView!

    ///Declare variable Employee structure
    var employeeData:Employee?
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
     Life cycle method called after view is loaded. Set data source and delegate of table view to self. Call initHudView method which initalizes the hud view.
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the
        tableView.dataSource = self
        tableView.delegate = self
        
        initHudView()
    }

    /**
    Called before the view is loaded. If employeeData is null, call method callEmployeeAPI which hits employee web service.
    */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if employeeData == nil {
            callEmployeeAPI()
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
    Method called when add employee button is clicked. Instantiate SignUpVC, set its delegate to self in view controller.  Add view as sub view of view controller and add SignUpVC as child view controller.
    */
    @IBAction func btnAddEmployeeDidClicked(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.SignUpVC) as! SignUpVC
        vc.delegate = self
        self.view.addSubview(vc.view)
        self.addChildViewController(vc)
        
    }
    
    // Show Edit Employee Form
    /**
    Method called when Edit employee button clicked. Instantiate EditEmployeeVC, set its delegate to self in view controller.
    If employeeData has employeeDetails, get its id and pass it in vc.
    Add view as sub view of view controller and add EditEmployeeVC as child view controller. 
    */
    @objc func btnEditDidClicked(sender:UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.EditEmployeeVC) as! EditEmployeeVC        
        /// Delegate is user defined property in EditEmployeeVC
        vc.delegate = self
        vc.employeeDetail = employeeData?.employeeDetails[sender.tag]
        self.view.addSubview(vc.view)
        self.addChildViewController(vc)
    }
    
    // Reload Employees list
    ///Reloads the rows and sections of the table view.
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    /** 
    Get employee details from web service. If UserManager class does not has restautant id, then return.
    Take parameter restaurant id from UserManager class. Display hud view. Call employee method from APIClient class and pass parameters.
    Hide hud view. If api hit is successful, pass the response to employeeData. Call reloadTable method which reloads rows and sections of table view.
    If api hit is not successful, if error message is noDataMessage or noDataMessage1 in Constants.swift, display message msgFailed in AppMessages.swift in dialog else display error message in dialog.
    */
    private func callEmployeeAPI() {
        guard let restaurentId = UserManager.restaurantID else {
            return
        }
        
        let prameterDic = ["RestaurantId":restaurentId]
        
        self.hudView.isHidden = false
        APIClient.employee(paramters: prameterDic) { (result) in
            self.hudView.isHidden = true
            switch result {
            case .success(let employee):
                self.employeeData = employee
                self.reloadTable()
                
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

extension EmployeeDetailVC:UITableViewDataSource {
    
    //How many sections are there in the tableview
    /**
     Method returns no. of sections of table view. Initialize no. of sections to 1. Set width and height of noDataLbl to width and height of table view.
     If  employeeData is not null and count of employeeDetails is 0, set noDataLbl text to No employees found, else set noDataLbl text to null.
     If employeeData is null, set noDataLbl text to No employees found. Set noDataLbl text color to theme color, its text alignment to center.
    Set background of table view to noDataLbl. Return numberOfSection
    */
    func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSection = 1
        
        let noDataLbl = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
        if let employee = employeeData {
            if employee.employeeDetails.count == 0 {
                noDataLbl.text = "No employees found"
            }else {
                noDataLbl.text = ""
            }
        } else {
            noDataLbl.text = "No employees found"
        }
        noDataLbl.textColor = UIColor.themeColor
        noDataLbl.textAlignment = .center
        tableView.backgroundView = noDataLbl
        
        return numberOfSection
    }
    
    /**
    This method returns no. of rows in section of table view. If employeeData is not null, return count of employeeDetails of employeeData.
    Return 0 by default.
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let employee = employeeData {
            return employee.employeeDetails.count
        }
        return 0
    }
    
    /**
    This method asks the data source for a cell to insert in a particular location of the table view. Set cell to EmployeeDetailCell if cell identifier is employeeDetailCell, else set cell to empty EmployeeDetailCell (default case which happens rarely). EmployeeDetailCell is reused here.
    Add handler to perform on click action on edit button at specified index of row. If employeeData is not null,
    set employee's name, email id, role type at specified index. If at particular index, employee's active value is true, set lblStatus at that index to Active: Yes else set Active: No.
    Return cell
    */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "employeeDetailCell") as? EmployeeDetailCell else {
            return EmployeeDetailCell()
        }
        
        ///  add handler to perform on click action on edit button
        cell.btnEdit.addTarget(self, action: #selector(btnEditDidClicked(sender:)), for: .touchUpInside)
        cell.btnEdit.tag = indexPath.row
        
        if let employees = employeeData {
            let employee = employees.employeeDetails[indexPath.row]
            cell.lblName.text = employee.username
            cell.lblEmail.text = employee.emailID
            cell.lblRole.text = employee.roleType
            if employee.active == "True" {
                cell.lblStatus.text = "Active: Yes"
            } else {
                cell.lblStatus.text = "Active: No"
            }
        }
        return cell
    }
}

extension EmployeeDetailVC:UITableViewDelegate {
    /**
     Asks the delegate for the height to use for a row in a specified location.
    */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    /**
     Asks the delegate for the estimated height of a row in a specified location. Set estimated height 220
     */
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
}

extension EmployeeDetailVC:EmployeeDetailDelegate {
    /**
    This method is called after adding or updating Employee and this method takes EmployeeDetail and reloads the table data.
    This method is called in removeController method in SignupVC. This method is used in to see the Employee detail only after adding an employee
    */
    func showDetail(detail: [EmployeeDetail]) {
            employeeData?.employeeDetails = detail
            self.reloadTable()
    }
}

extension EmployeeDetailVC:EditEmployeeDelegate {
    /**
    This method is called when user wants to update any employee data. This also calls the api to update data on server.
    This method is called from EditEmployeeVC.
    */
    func updateEmployee() {
        callEmployeeAPI()
    }
}
