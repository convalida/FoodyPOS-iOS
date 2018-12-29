//
//  AllBestSellerVC.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 22/11/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

class AllBestSellerVC: UIViewController {

    @IBOutlet weak var btnStartDate: UIButton!
    @IBOutlet weak var btnEndDate: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var btnBack: UIButton!
    
    var statusData = [Status]()
    var bestSellerData:AllBestSeller?
    var hudView = UIView()
    var type = ""
    var isSearch:Bool = false
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        initHudView()
        if type == "week" {
            let lastSun = Date.today().previous(.sunday)
            btnStartDate.setTitle(lastSun.getDateString(), for: .normal)
            btnBack.setTitle("Weekly Bestseller items", for: .normal)
        }else if type == "month" {
            btnStartDate.setTitle(Date.startOfMonth().getDateString(), for: .normal)
            btnBack.setTitle("Monthly Bestseller items", for: .normal)

        }else if type == "year" {
             btnStartDate.setTitle(Date.startOfYear().getDateString(), for: .normal)
            btnBack.setTitle("Yearly Bestseller items", for: .normal)
        }
        
        btnEndDate.setTitle(Date.todayDate, for: .normal)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
        if bestSellerData == nil {
            callAllBestSellerAPI()
        }
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
    
    //MARK: ---------Button actions---------
    @IBAction func btnDateStartDidClicked(_ sender: UIButton) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date.today()
        if let date = Date.getDate(fromString: (sender.titleLabel?.text)!) {
            datePicker.date = date
        }
        Alert.showDatePicker(dataPicker: datePicker, controller: self, viewRect: sender) { (date) in
            sender.setTitle(date.getDateString(), for: .normal)
        }
    }
    
    @IBAction func btnDateEndDidClicked(_ sender: UIButton) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date.today()
        if let date = Date.getDate(fromString: (sender.titleLabel?.text)!) {
            datePicker.date = date
        }
        Alert.showDatePicker(dataPicker: datePicker, controller: self, viewRect: sender) { (date) in
            sender.setTitle(date.getDateString(), for: .normal)
        }
    }
    
    @IBAction func btnBackDidClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSearchDidClicked(_ sender: UIButton) {
        if Date.getDate(fromString: (btnStartDate.titleLabel?.text)!)! <= Date.getDate(fromString: (btnEndDate.titleLabel?.text)!)! {
            isSearch = true
            callAllBestSellerAPI()
        }else {
            self.showToast("Start date must be less than or equal to end date")
        }
    }
    
    private func callAllBestSellerAPI() {
        guard let restaurentId = UserManager.restaurantID else {
            return
        }
        var prameterDic:[String:Any]
      //  if isSearch {
            prameterDic = ["RestaurantId":restaurentId,
                           "fromdate":(btnStartDate.titleLabel?.text)!,
                           "enddate":(btnEndDate.titleLabel?.text)!] as [String : Any]
//        }else {
//            prameterDic = ["RestaurantId":restaurentId,
//                           "fromdate":"null".replacingOccurrences(of: "\"", with: ""),
//                           "enddate":"null".replacingOccurrences(of: "\"", with: "")] as [String : Any]
//        }
       
        
        self.hudView.isHidden = false
        APIClient.getAllBestSeller(paramters: prameterDic) { (result) in
            self.hudView.isHidden = true
            switch result {
            case .success(let bestSeller):
                self.bestSellerData = bestSeller
                self.initData()
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
    
    func initData() {
        statusData.removeAll()
        if let data = bestSellerData {
            if let dateSelection = data.by_DateSelection {
                if type == "week" {
                    if let weeklyData = dateSelection.weeklyBestsellerItems {
                        for i in 0..<weeklyData.count {
                            var status = Status()
                            status.isOpened = (i == 0) ? true : false
                            statusData.append(status)
                        }

                    }
                } else if type == "month" {
                    if let monthData = dateSelection.monthlyBestsellerItems {
                        for i in 0..<monthData.count {
                            var status = Status()
                            status.isOpened = (i == 0) ? true : false
                            statusData.append(status)
                        }
                        
                    }
                } else if type == "year" {
                    if let yearData = dateSelection.yearlyBestsellerItems {
                        for i in 0..<yearData.count {
                            var status = Status()
                            status.isOpened = (i == 0) ? true : false
                            statusData.append(status)
                        }
                        
                    }
                }
            }
        }
    }
    
    //Reload the table
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.tableView.setContentOffset(.zero, animated: false)
        })
    }
}

extension AllBestSellerVC:UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let noDataLbl = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
        if let data = bestSellerData {
            if let dateSelection = data.by_DateSelection {
                if type == "week" {
                    if let weeklyData = dateSelection.weeklyBestsellerItems {
                        if weeklyData.count == 0 {
                            noDataLbl.text = "No data found"
                        }else {
                            noDataLbl.text = ""
                        }
                        noDataLbl.textColor = UIColor.themeColor
                        noDataLbl.textAlignment = .center
                        tableView.backgroundView = noDataLbl
                        return weeklyData.count
                    }
                } else if type == "month" {
                    if let monthData = dateSelection.monthlyBestsellerItems {
                        if monthData.count == 0 {
                            noDataLbl.text = "No data found"
                        }else {
                            noDataLbl.text = ""
                        }
                        noDataLbl.textColor = UIColor.themeColor
                        noDataLbl.textAlignment = .center
                        tableView.backgroundView = noDataLbl
                        return monthData.count
                    }
                } else if type == "year" {
                    if let yearData = dateSelection.yearlyBestsellerItems {
                        if yearData.count == 0 {
                            noDataLbl.text = "No data found"
                        }else {
                            noDataLbl.text = ""
                        }
                        noDataLbl.textColor = UIColor.themeColor
                        noDataLbl.textAlignment = .center
                        tableView.backgroundView = noDataLbl
                        return yearData.count
                    }
                }
            }else {
                noDataLbl.text = "No data found"
                noDataLbl.textColor = UIColor.themeColor
                noDataLbl.textAlignment = .center
                tableView.backgroundView = noDataLbl
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if statusData[section].isOpened {
            if let data = bestSellerData {
                if let dateSelection = data.by_DateSelection {
                    if type == "week" {
                        if let weeklyData = dateSelection.weeklyBestsellerItems {
                            if let itemDetails = weeklyData[section].items_Details {
                                return itemDetails.count + 1
                            }
                        }
                    } else if type == "month" {
                        if let monthData = dateSelection.monthlyBestsellerItems {
                            if let itemDetails = monthData[section].items_Details {
                                return itemDetails.count + 1
                            }
                        }
                    } else if type == "year" {
                        if let yearData = dateSelection.yearlyBestsellerItems {
                            if let itemDetails = yearData[section].items_Details {
                                return itemDetails.count + 1
                            }
                        }
                    }
                }
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as? AllBestSellerCell else {
                return UITableViewCell()
            }
            if let data = bestSellerData {
                if let dateSelection = data.by_DateSelection {
                    if statusData[indexPath.section].isOpened {
                        cell.imgHeader.transform = CGAffineTransform(rotationAngle: .pi)
                    }else {
                        cell.imgHeader.transform = CGAffineTransform.identity
                    }
                    if type == "week" {
                        if let weeklyData = dateSelection.weeklyBestsellerItems {
                            if let week = weeklyData[indexPath.section].week {
                                cell.lblHeaderTitle.text = week
                            }
                        }
                    } else if type == "month" {
                        if let monthData = dateSelection.monthlyBestsellerItems {
                            if let month = monthData[indexPath.section].month {
                                cell.lblHeaderTitle.text = month
                            }
                        }
                    } else if type == "year" {
                        if let yearData = dateSelection.yearlyBestsellerItems {
                            if let year = yearData[indexPath.section].year {
                                cell.lblHeaderTitle.text = year
                            }
                        }
                    }
                }
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as? AllBestSellerCell else {
                return UITableViewCell()
            }
            if let data = bestSellerData {
                if let dateSelection = data.by_DateSelection {
                    if type == "week" {
                        if let weeklyData = dateSelection.weeklyBestsellerItems {
                            if let week = weeklyData[indexPath.section].items_Details {
                                if let item = week[indexPath.row - 1].subitems {
                                    cell.lblItemName.text = item
                                }
                                if let count = week[indexPath.row - 1].counting {
                                    cell.lblItemCount.text = count
                                }
                            }
                        }
                    } else if type == "month" {
                        if let monthData = dateSelection.monthlyBestsellerItems {
                            if let month = monthData[indexPath.section].items_Details {
                                if let item = month[indexPath.row - 1].subitems {
                                    cell.lblItemName.text = item
                                }
                                if let count = month[indexPath.row - 1].counting {
                                    cell.lblItemCount.text = count
                                }
                            }
                        }
                    } else if type == "year" {
                        if let yearData = dateSelection.yearlyBestsellerItems {
                            if let year = yearData[indexPath.section].items_Details {
                                if let item = year[indexPath.row - 1].subitems {
                                    cell.lblItemName.text = item
                                }
                                if let count = year[indexPath.row - 1].counting {
                                    cell.lblItemCount.text = count
                                }
                                
                            }
                        }
                    }
                }
            }
            return cell
        }
    }
}


extension AllBestSellerVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if statusData[indexPath.section].isOpened {
                statusData[indexPath.section].isOpened = false
            }else {
                statusData[indexPath.section].isOpened = true
            }
            let sections = IndexSet(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
}
