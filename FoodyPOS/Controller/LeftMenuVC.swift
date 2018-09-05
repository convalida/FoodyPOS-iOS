//
//  LeftMenuVC.swift
//  FoodyPOS
//
//  Created by rajat on 29/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

class LeftMenuVC: UIViewController {
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Global.isIpad {
            self.tableView.tableHeaderView?.frame.size.height = 300.0
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension LeftMenuVC:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return LeftMenu.MainData.count
        }
        return LeftMenu.ProfileData.count
    }
    
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
        }else {
            cell.lblTitle.text = LeftMenu.ProfileData[indexPath.row].title
            cell.imgIcon.image =  LeftMenu.ProfileData[indexPath.row].image
        }
        
        return cell
    }
}

extension LeftMenuVC:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 {
            return 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerCell = tableView.dequeueReusableCell(withIdentifier: LeftMenu.CellIdentifier.headerCell) as? LeftMenuCell else {
            return LeftMenuCell()
        }
        switch section {
        case 1:
            headerCell.lblHeader.text = "Profile"
        default:
            headerCell.lblHeader.text = ""
            headerCell.viewBorder.isHidden = true
        }
        return headerCell
    }
    
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
                self.navigationController?.pushViewController(vc, animated: true)
                
            case 3:
                parentVC?.leftSlideMenu.close()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.SalesReportVC) as! SalesReportVC
                self.navigationController?.pushViewController(vc, animated: true)
                
            default:
                print("Default")
            }
            
        case 1:
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
                if UserManager.isRemember {
                    UserManager.isLogin = false
                    Global.showRootView(withIdentifier: StoryboardConstant.LoginVC)
                }else {
                    Global.flushUserDefaults()
                    self.navigationController?.popToRootViewController(animated: true)
                }

            default:
                print("default")
            }
        default:
            print("Default")
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !UserManager.isManager {
            if indexPath.section == 1 {
                if indexPath.row == 0 {
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
