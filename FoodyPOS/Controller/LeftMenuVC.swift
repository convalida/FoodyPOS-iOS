//
//  LeftMenuVC.swift
//  FoodyPOS
//
//  Created by rajat on 29/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

///Class for Left menu view controller
class LeftMenuVC: UIViewController {
    ///Outlet for banner image
    @IBOutlet weak var imgLogo: UIImageView!
    ///Outlet for table view below image
    @IBOutlet weak var tableView: UITableView!
    var customersData:Customers?

    ///Display status bar
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    ///A light status bar, intended for use on dark backgrounds.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    ///Instantiate hud view
    var hudView = UIView()

    /**
     Called after the controller's view is loaded into memory. Set data source and delegate of table view to self. Initialize hud view
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        initHudView()
        
    }

    /**
     Notifies the view controller that its view is about to be added to a view hierarchy. If device is iPad, set height of header view ( view that is displayed above the table) as 300.0
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Global.isIpad {
            self.tableView.tableHeaderView?.frame.size.height = 300.0
        }
    }
    
    /// Sent to the view controller when the app receives a memory warning.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Initialize hud view. Set background color of hud view to white, set constraints to top, bottom, left and right, add hud view and hide it
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
}

extension LeftMenuVC:UITableViewDataSource {
    /**
     Asks the data source to return the number of sections in the table view. Return no. of sections- 2
 */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    /**
     Tells the data source to return the number of rows in a given section of a table view. For 0th section, return count of MainData containing Dashboard, Orders, Customer Details, Reports. In other case, return count of ProfileData consisting of Employee, ChangePassword, Logout
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return LeftMenu.MainData.count
        }
        else if section==1{
            return LeftMenu.CatalogData.count
        }
        else if section==2{
            return LeftMenu.RestaurantData.count
        }
        return LeftMenu.UserData.count
    }

    
    
    /**
     Asks the data source for a cell to insert in a particular location of the table view. Set cell of LeftMenu as LeftMenuCell if CellIdentifier is menuCell (displaying items - child of header items) declared in LeftMenu struct else also return LeftMenuCell as previous.
     For 0th section, set lblTitle text to MainData array row's title, imgIcon as image in MainData array's row image. For zeroth row, set text color to theme color.
     For other section, set lblTitle text to ProfileData array row's title, imgIcon as image in ProfileData array's row image and return cell
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LeftMenu.CellIdentifier.menuCell) as? LeftMenuCell else {
            return LeftMenuCell()
        }
        
        if indexPath.section == 0 {
            cell.lblTitle.text = LeftMenu.MainData[indexPath.row].title
            cell.imgIcon.image =  LeftMenu.MainData[indexPath.row].image
            if indexPath.row == 0 {
                cell.lblTitle.textColor = UIColor.themeColor
            }
        }else if indexPath.section == 1{
            cell.lblTitle.text = LeftMenu.CatalogData[indexPath.row].title
            cell.imgIcon.image =  LeftMenu.CatalogData[indexPath.row].image
        }
        else if indexPath.section==2{
            cell.lblTitle.text = LeftMenu.RestaurantData[indexPath.row].title
            cell.imgIcon.image = LeftMenu.RestaurantData[indexPath.row].image
        }
        else if indexPath.section == 3{
            cell.lblTitle.text = LeftMenu.UserData[indexPath.row].title
            cell.imgIcon.image = LeftMenu.UserData[indexPath.row].image
        }
        return cell
    }
}

extension LeftMenuVC:UITableViewDelegate {
    /**
     Asks the delegate for the height to use for the header of a particular section. If height of header section is not 0, set height of header section 50, in other cases set height of header 0.
     */
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 {
            return 50
        }
        return 0
    }
    
    /**
     Asks the delegate for a view object to display in the header of the specified section (Eg - Profile) of the table view. Set cell of LeftMenu as LeftMenuCell if CellIdentifier is headerCell declared in LeftMenu struct else also return LeftMenuCell as previous.
     For section 1, set heading of menu items to Profile, by default, set heading of menu items to null and hide border. Return header cell. For section 1, border is visble, set in storyboard.
     */
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerCell = tableView.dequeueReusableCell(withIdentifier: LeftMenu.CellIdentifier.headerCell) as? LeftMenuCell else {
            return LeftMenuCell()
        }
        switch section {
        case 1:
            headerCell.lblHeader.text = "CATALOG"
        case 2:
            headerCell.lblHeader.text = "RESTAURANT"
        case 3:
            headerCell.lblHeader.text = "USER"
        default:
            headerCell.lblHeader.text = ""
            headerCell.viewBorder.isHidden = true
        }
        return headerCell
    }

    /**
    This method gets called if row of table view is selected. Set DashboardVC as parentVC. If selected section
    is section 0, if row 0 of section 0 is selected, then close left slide menu of parentVC. If row 1 of section 0 is selected, close left slide menu, instantiate OrderListVC and push VC.
    If row 2 of section 0 is selected, close left slide menu, instantiate SalesSellAllVC and push vc. If row 3
    of section 0 is selected, close left slide menu, instantiate SalesReportVC and push vc. In default case,
    print Default in logs. In case of section 1, if row 0 of section 1 is selected, instantiate EmployeeDetailVC, close left slide menu, and push vc.
    If row 1 of section 1 is selected, instantiate ChangePasswordVC, close left slide menu and push vc.
    If row 2 of section 1 is selected, close left slide menu, if UserManager class has token value, fetch that
    value and after trimming it, if it returns null string, display in toast a message that user is looged out. If isRemember value in UserManager class is true, then set isLogin value in UserManager class to false and display root view controller with identifier LoginVC. If isRemember value in UserManager class is false, call flushUserDefaults method in Global class which clears all user default data. Instantaite LoginVC and push vc. Return in both cases if isRemember value is UserManager is true or false. The same steps are followed in case UserManager class does not has token value.
    If isRemember value in UserManager class is true, then set isLogin value in UserManager class to false and
    display root view controller with identifier LoginVC. If isRemember value in UserManager class is false,
    call flushUserDefaults method in Global class which clears all user default data. Instantaite LoginVC and
    push vc. Return in both cases if isRemember value in UserManager is true or false. The same steps are
    followed in case UserManager class does not has token value. Take token from UserManager class, and assign
    it deviceId parameter. Display hud view. Call logout method in APIClient class. If api hit is successful
    and result code is 1, then show message in toast that user logged out, if isRemember value in UserManager
    class is true, then set isLogin value in UserManager class to false and display root view controller with
    identifier LoginVC. If isRemember value in UserManager class is false, call flushUserDefaults method in
    Global class which clears all user default data. Instantaite LoginVC and push vc. If result code is not 1,
    display message in response in toast. If api hit is not successful, if error message is noDataMessage or
    noDataMessage1 in Constants.swift, display message msgFailed in AppMessages.swift in dialog else display
    error message in dialog. In default case, print default in logs.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let parentVC = self.parent as? DashboardVC
//        let cell = tableView.cellForRow(at: indexPath) as! LeftMenuCell
//        cell.lblTitle.textColor = UIColor.themeColor
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                parentVC?.leftSlideMenu.close()
                
            case 1:
                parentVC?.leftSlideMenu.close()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.OrderListVC) as! OrderListVC
                self.navigationController?.pushViewController(vc, animated: true)
                
            case 2:
                parentVC?.leftSlideMenu.close()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.SalesSellAllVC) as! SalesSellAllVC
                vc.isCustomer=true
                self.navigationController?.pushViewController(vc, animated: true)
                
            case 3:
                parentVC?.leftSlideMenu.close()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.SalesReportVC) as! SalesReportVC
                self.navigationController?.pushViewController(vc, animated: true)
                
            default:
                print("Default")
            }
            
        case 1:

            switch indexPath.row{
            case 0:
                parentVC?.leftSlideMenu.close()
              let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.MenuVC) as! MenuVC
            self.navigationController?.pushViewController(vc, animated: true)
                
            case 1:
                parentVC?.leftSlideMenu.close()
             //   let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.NotificationsVC) as! NotificationsVC
              //  self.navigationController?.pushViewController(vc, animated: true)
           
            default:
                print("Default")
            }
            
        case 3:

            switch indexPath.row {
            case 0:
                let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.EmployeeDetailVC) as! EmployeeDetailVC
                parentVC?.leftSlideMenu.close()
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.ChangePasswordVC) as! ChangePasswordVC
                parentVC?.leftSlideMenu.close()
                self.navigationController?.pushViewController(vc, animated: true)
            case 2:
                parentVC?.leftSlideMenu.close()
                if let token = UserManager.token {
                    if token.trim() == "" {
                        self.showToast("You are successfully logged out")
                        if UserManager.isRemember {
                            UserManager.isLogin = false
                            Global.showRootView(withIdentifier: StoryboardConstant.LoginVC)
                        }else {
                            Global.flushUserDefaults()
                            //self.navigationController?.popToRootViewController(animated: true)
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.LoginVC) as! LoginVC
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        return
                    }
                } else {
                    self.showToast("You are successfully logged out")
                    if UserManager.isRemember {
                        UserManager.isLogin = false
                        Global.showRootView(withIdentifier: StoryboardConstant.LoginVC)
                    }else {
                        Global.flushUserDefaults()
                       // self.navigationController?.popToRootViewController(animated: true)
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.LoginVC) as! LoginVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    return
                }
                let parameterDic = ["deviceId":UserManager.token ?? " "]
                parentVC?.hudView.isHidden = false
                APIClient.logout(paramters: parameterDic) { (result) in
                    switch result {
                    case .success(let user):
                        if let result = user.result {
                            if result == "1" {
                                self.showToast("You are successfully logged out")
                                if UserManager.isRemember {
                                    UserManager.isLogin = false
                                    Global.showRootView(withIdentifier: StoryboardConstant.LoginVC)
                                }else {
                                    Global.flushUserDefaults()
                                   // self.navigationController?.popToRootViewController(animated: true)
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.LoginVC) as! LoginVC
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            } else if let message = user.message {
                                parentVC?.hudView.isHidden = true
                                DispatchQueue.main.async {
                                    self.showToast(message)
                                }
                            }
                        }
                        
                    case .failure(let error):
                        parentVC?.hudView.isHidden = true
                        if error.localizedDescription == noDataMessage || error.localizedDescription == noDataMessage1 {
                            self.showAlert(title: kAppName, message: AppMessages.msgFailed)
                        } else {
                            self.showAlert(title: kAppName, message: error.localizedDescription)
                        }
                    }
                }
            default:
                print("default")
            }
        default:
            print("Default")
        }
    }

/**
Method for height of row of table view. If isManager in UserManager class is false, then for row 0 of section 1,
set height to 0. If device is iPad, set height of row to 80, else set height of row to 56
*/
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !UserManager.isManager {
            if indexPath.section == 3 {
                if indexPath.row == 0 {
                    // to hide first row of second section
                    return 0
                }
            }
        }
        if Global.isIpad {
            return 80.0
        }
        return 56.0
    }
}
