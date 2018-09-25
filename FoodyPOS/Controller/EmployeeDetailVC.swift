//
//  EmployeeDetailVC.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 04/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

class EmployeeDetailVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewTop: UIView!

    var employeeData:Employee?
    var hudView = UIView()
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the
        tableView.dataSource = self
        tableView.delegate = self
        
        initHudView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if employeeData == nil {
            callEmployeeAPI()
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
    
    @IBAction func btnAddEmployeeDidClicked(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.SignUpVC) as! SignUpVC
        vc.delegate = self
        self.view.addSubview(vc.view)
        self.addChildViewController(vc)
        
    }
    
    @objc func btnEditDidClicked(sender:UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.EditEmployeeVC) as! EditEmployeeVC
        vc.delegate = self
        vc.employeeDetail = employeeData?.employeeDetails[sender.tag]
        self.view.addSubview(vc.view)
        self.addChildViewController(vc)
    }
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
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
                if error.localizedDescription == noDataMessage {
                    self.showAlert(title: kAppName, message: AppMessages.msgFailed)
                }else {
                    self.showAlert(title: kAppName, message: error.localizedDescription)
                }
            }
        }
    }
}

extension EmployeeDetailVC:UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let employee = employeeData {
            return employee.employeeDetails.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "employeeDetailCell") as? EmployeeDetailCell else {
            return EmployeeDetailCell()
        }
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
}

extension EmployeeDetailVC:EmployeeDetailDelegate {
    func showDetail(detail: [EmployeeDetail]) {
            employeeData?.employeeDetails = detail
            self.reloadTable()
    }
}

extension EmployeeDetailVC:EditEmployeeDelegate {
    func updateEmployee() {
        callEmployeeAPI()
    }
}
