//
//  BestSellerVC.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 04/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

class BestSellerVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewTop: UIView!

    var bestSellerData:BestSeller?
    var hudView = UIView()
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        initHudView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if bestSellerData == nil {
            getBestSellerData()
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
    
    //MARK: Button Actions
    @IBAction func btnBackDidClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //Reload table
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func getBestSellerData() {
        guard let restaurentId = UserManager.restaurantID else {
            return
        }
        let prameterDic = ["RestaurantId":restaurentId]
        
        self.hudView.isHidden = false
        APIClient.bestSellerItems(paramters: prameterDic) { (result) in
            self.hudView.isHidden = true
            switch result {
            case .success(let bestSeller):
                print(bestSeller)
                self.bestSellerData = bestSeller
                self.reloadTable()
                
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

extension BestSellerVC:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSection = 1
        
        let noDataLbl = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
        if bestSellerData == nil {
            noDataLbl.text = "No bestsellers found"
        }else {
            noDataLbl.text = ""
        }
        noDataLbl.textColor = UIColor.themeColor
        noDataLbl.textAlignment = .center
        tableView.backgroundView = noDataLbl
        
        return numberOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if bestSellerData != nil {
            return 3
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bestSellerCell") as? BestSellerCell else {
            return BestSellerCell()
        }
        
        func setDefault() {
            cell.lblItem1.text = ""
            cell.lblValue1.text = ""
            cell.lblItem2.text = "       No Items"
            cell.lblItem2.textAlignment = .center
            cell.lblValue2.text = ""
            cell.lblItem3.text = ""
            cell.lblValue3.text = ""
        }
        
        if let bestSellerData = bestSellerData {
            switch indexPath.row {
            case 0:
                cell.lblTitle.text = "Weekly Bestseller Items"
                if bestSellerData.weeklyBestsellersItem.count > 0 {
                    if bestSellerData.weeklyBestsellersItem.count >= 1 {
                        if let item1 = bestSellerData.weeklyBestsellersItem[0] {
                            cell.lblItem1.text = item1.subitems
                            cell.lblValue1.text = item1.counting
                        }
                    }else {
                        cell.lblItem1.text = ""
                        cell.lblValue1.text = ""
                    }
                    
                    
                    if bestSellerData.weeklyBestsellersItem.count >= 2 {
                        if let item2 = bestSellerData.weeklyBestsellersItem[1] {
                            cell.lblItem2.text = item2.subitems
                            cell.lblValue2.text = item2.counting
                        }
                    }else {
                        cell.lblItem2.text = ""
                        cell.lblValue2.text = ""
                    }

                    if bestSellerData.weeklyBestsellersItem.count >= 3 {
                        if let item3 = bestSellerData.weeklyBestsellersItem[2] {
                            cell.lblItem3.text = item3.subitems
                            cell.lblValue3.text = item3.counting
                        }
                    }else {
                        cell.lblItem3.text = ""
                        cell.lblValue3.text = ""
                    }
                }else {
                    setDefault()
                }
                
            case 1:
                cell.lblTitle.text = "Monthly Bestseller Items"
                if bestSellerData.monthelyBestsellersItem.count > 0 {
                    if bestSellerData.monthelyBestsellersItem.count >= 1 {
                        if let item1 = bestSellerData.monthelyBestsellersItem[0] {
                            cell.lblItem1.text = item1.subitems
                            cell.lblValue1.text = item1.counting
                        }
                    }else {
                        cell.lblItem1.text = ""
                        cell.lblValue1.text = ""
                    }
                    
                    
                    if bestSellerData.monthelyBestsellersItem.count >= 2 {
                        if let item2 = bestSellerData.monthelyBestsellersItem[1] {
                            cell.lblItem2.text = item2.subitems
                            cell.lblValue2.text = item2.counting
                        }
                    }else {
                        cell.lblItem2.text = ""
                        cell.lblValue2.text = ""
                    }
                    
                    if bestSellerData.monthelyBestsellersItem.count >= 3 {
                        if let item3 = bestSellerData.monthelyBestsellersItem[2] {
                            cell.lblItem3.text = item3.subitems
                            cell.lblValue3.text = item3.counting
                        }
                    }else {
                        cell.lblItem3.text = ""
                        cell.lblValue3.text = ""
                    }
                }else {
                    setDefault()
                }
                
            case 2:
                cell.lblTitle.text = "Yearly Bestseller Items"
                if bestSellerData.yearlyBestsellersItem.count > 0 {
                    if bestSellerData.yearlyBestsellersItem.count >= 1 {
                        if let item1 = bestSellerData.yearlyBestsellersItem[0] {
                            cell.lblItem1.text = item1.subitems
                            cell.lblValue1.text = item1.counting
                        }
                    }else {
                        cell.lblItem1.text = ""
                        cell.lblValue1.text = ""
                    }
                    
                    
                    if bestSellerData.yearlyBestsellersItem.count >= 2 {
                        if let item2 = bestSellerData.yearlyBestsellersItem[1] {
                            cell.lblItem2.text = item2.subitems
                            cell.lblValue2.text = item2.counting
                        }
                    }else {
                        cell.lblItem2.text = ""
                        cell.lblValue2.text = ""
                    }
                    
                    if bestSellerData.yearlyBestsellersItem.count >= 3 {
                        if let item3 = bestSellerData.yearlyBestsellersItem[2] {
                            cell.lblItem3.text = item3.subitems
                            cell.lblValue3.text = item3.counting
                        }
                    }else {
                        cell.lblItem3.text = ""
                        cell.lblValue3.text = ""
                    }
                }else {
                    setDefault()
                }
                
            default:
                print("Default")
            }
        }
        cell.btnAll.tag = indexPath.row
        cell.btnAll.addTarget(self, action: #selector(btnAllDidClicked(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func btnAllDidClicked(sender:UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.AllBestSellerVC) as! AllBestSellerVC
        if sender.tag == 0 {
            vc.type = "week"
        } else if sender.tag == 1 {
            vc.type = "month"
        } else if sender.tag == 2 {
            vc.type = "year"
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension BestSellerVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if Global.isIpad {
            return 200.0
        }
        return 150.0
    }
}
