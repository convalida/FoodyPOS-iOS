//
//  DashboardVC.swift
//  FoodyPOS
//
//  Created by rajat on 28/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit
import Highcharts

class DashboardVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var leftSlideMenu:LeftSlideMenu!

    //MARK: ---------View Life Cycle---------
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        //Initialize left slide menu
        leftSlideMenu = LeftSlideMenu(vc: self)
        
        //enable left edge gesture
        leftSlideMenu.enableLeftEdgeGesture()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: ---------Button actions---------

    @IBAction func btnMenuDidClicked(_ sender: UIButton) {
        leftSlideMenu.open()
    }
    
    @IBAction func btnOptionsDidClicked(_ sender: UIButton) {
        let settings = KxMenuItem.init("Settings", image: nil, target: self, action: #selector(pushMenuItem(sender:)))
        settings?.foreColor = UIColor.black
        
        let changePassword = KxMenuItem.init("Change Password", image: nil, target: self, action: #selector(pushMenuItem(sender:)))
        changePassword?.foreColor = UIColor.black
        
        let logout = KxMenuItem.init("Logout", image: nil, target: self, action: #selector(pushMenuItem(sender:)))
        logout?.foreColor = UIColor.black
        
        let menuItems = [settings,changePassword,logout]
        
        KxMenu.show(in: self.view, from: sender.frame, menuItems: menuItems)
    }
    
    @IBAction func btnTopSaleDidClicked(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.TopSaleVC) as! TopSaleVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnOrderListDidClicked(_ sender: UIButton) {
    }
    
    @IBAction func btnBestSellerDidClicked(_ sender: UIButton) {
    }
    
    @objc func pushMenuItem(sender:KxMenuItem) {
        KxMenu.dismiss()
        switch sender.title {
        case "Settings":
            print("Settings")
            
        case "Change Password":
            let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.ChangePasswordVC) as! ChangePasswordVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "Logout":
            self.navigationController?.popToRootViewController(animated: true)

        default:
            print("default")
        }
    }
}

extension DashboardVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Dashboard.titleArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let totalRows = tableView.numberOfRows(inSection: 0)
        if indexPath.row != totalRows-1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Dashboard.CellIdentifier.dashboardCell) as? DashboardCell else {
                return DashboardCell()
            }
            
            cell.lblTitle.text = Dashboard.titleArray[indexPath.row]
            cell.viewColor.backgroundColor = UIColor.randomColor
            cell.lblValue.text = "$556556"
            
            return cell
        }else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Dashboard.CellIdentifier.dashboardGraphCell) as? DashboardGraphCell else {
                return DashboardGraphCell()
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
}

extension DashboardVC:UITableViewDelegate {
    
}
