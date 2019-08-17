//
//  AllBestSellerVC.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 22/11/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

///View controller class for AllBestSellerVC
class AllBestSellerVC: UIViewController {

    ///Outlet for start date 
    @IBOutlet weak var btnStartDate: UIButton!
    ///Outlet for end date
    @IBOutlet weak var btnEndDate: UIButton!
    ///Outlet for table view
    @IBOutlet weak var tableView: UITableView!
    ///Outlet for top view or navigation bar
    @IBOutlet weak var viewTop: UIView!
    ///Outlet for back button
    @IBOutlet weak var btnBack: UIButton!
    
    ///Declare variable for open/close status of collapsible groups
    var statusData = [Status]()
    ///Declare variable for AllBestSeller structure 
    var bestSellerData:AllBestSeller?
    ///Instantiate hud view
    var hudView = UIView()
    ///Initialize variable type to null
    var type = ""
    ///Initialize boolean variable isSearch to false
    var isSearch:Bool = false
    
    ///Set status bar to visible 
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
     ///Set light content of status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /**
    Life cycle method called after view is loaded. Set delegate and data source of table view to self.
    Call initHudView method which initializes the hud view. If value of type is week. This value is set depending on value passed in vc when called from BestSellerVC based on view more is clicked from weekly, monthly or yearly section. Rajat ji kindly check this.
    If type value is week, set start date to previous occurance of Monday in current week, considering today's date.
    Set title of back button to Weekly Bestseller items. Rajat ji please confirm if back button has a title which displays weekly/monthly/yearly bestseller items.
     If type value is month, set start date to first date of current month.
    Set title of back button to Monthly Bestseller items. 
     If type value is year, set start date to first date of current year.
    Set title of back button to Yearly Bestseller items. Set end date to today's date   
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        initHudView()
        if type == "week" {
            let lastSun = Date.today().previous(.monday)
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

    /**
    Called before the view is loaded. If bestSellerData is null, i.e., it is called for first time.
    Call method callAllBestSellerAPI method which hits getAllBestSellerAPI method.
    */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
        if bestSellerData == nil {
            callAllBestSellerAPI()
        }
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
    
    //MARK: ---------Button actions---------
    /**
    Method called when start date button is clicked. Instantiate date picker. Set date picker mode to date. Set maximum date to today's date.
    If there is date in fromDate, then set date in datepicker equal to date in button which is clicked. Show date picker in alert.
    Set title of from string to date selected in date picker.
    */
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
    
     /**
    Method called when end date is clicked. Instantiate date picker. Set date picker mode to date. Set maximum date to today's date.
    If there is date in endDate, then set date in datepicker equal to date in button which is clicked. Show date picker in alert.
    Set title of end string to date selected in date picker. 
    */
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
    
    ///Back button clicked. Pop the top view controller from stack
    @IBAction func btnBackDidClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /**
    Method called when search button is clicked after selecting start date and end date. 
    If date in btnStartDate is less than or equal to date in btnEndDate. Set isSearch to true. Call method callAllBestSellerAPI method.
    If date in btnStartDate is greater than date in btnEndDate, show toast message Start date must be less than or equal to end date

    */
    @IBAction func btnSearchDidClicked(_ sender: UIButton) {
        if Date.getDate(fromString: (btnStartDate.titleLabel?.text)!)! <= Date.getDate(fromString: (btnEndDate.titleLabel?.text)!)! {
            isSearch = true
            callAllBestSellerAPI()
        }else {
            self.showToast("Start date must be less than or equal to end date")
        }
    }
    
    /**
    Method called in viewWillAppear and when search button is clicked. If UserManager does not have restaurant id, then return.
    Take parameter restaurant id from UserManager class, start date and end dates from btnStartDate and btnEndDate resp.
    Display hud view. Call getAllBestSeller method from APIClient class and pass parameters. Hide hud view.
    If api hit is successful, set response to bestSellerData. Call method initData which sets the status for all sections in weekly, monthly and yearly bestseller items.
    Call reloadTable method which reloads the table. If api hit is not successful, if error message is noDataMessage or noDataMessage1 in Constants.swift, display message msgFailed in AppMessages.swift in dialog else display error message in dialog.
    */
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
    
    /**
    This method is called when allBestSeller api hit is successful. Remove all elements from statusData array.
    If bestSellerData is not null, if by_DateSelection in bestSellerData is not null, if type of selection is week,
    if weeklyBestsellerItems in by_DateSelection is not null, for all elements from 0 to no. of elements in weeklyBestseller items,
    instantiate Status. For 0th item, set status of row to opened, for other items, set status of row to closed.
    Append status of all rows to statusData array.
    If type selected is month, if monthlyBestsellerItems in by_DateSelection is not null, for all elements from 0 to no. of elements in monthlyBestseller items,
    instantiate Status. For 0th item, set status of row to opened, for other items, set status of row to closed.
    Append status of all rows to statusData array.
    If type selected is year, if yearlyBestsellerItems in by_DateSelection is not null, for all elements from 0 to no. of elements in yearlyBestseller items,
    instantiate Status. For 0th item, set status of row to opened, for other items, set status of row to closed.
    Append status of all rows to statusData array. 
    */
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
    /**
    Method called when allBestseller api hit is successful. Reload rows and sections of table view. 
    Call method scrollToTop which scrolls the list to top without animation. Rajat ji please check this. 
    */
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.tableView.scrollToTop(animated: false)
        })
    }
}

extension AllBestSellerVC:UITableViewDataSource {
    
    /**
    This method returns no. of sections. Set width and height of noDataLbl to width and height of table view. If bestsellerData is not null,
    if by_DateSelection in bestSellerData is is not null, if type of selection is week, if weeklyBestSellerItems in by_DateSelection is not null,
    if count of items in weeklyBestsellerItems is 0, set noDataLbl text to No data found else set noDataLbl text to null.
    Set noDataLbl text color to theme color, its alignment to center, set background to tableview to noDataLbl. Return no. of items in weeklyBestseller items.
    If type of selection is month, if monthlyBestSellerItems in by_DateSelection is not null,
    if count of items in monthlyBestsellerItems is 0, set noDataLbl text to No data found else set noDataLbl text to null.
    Set noDataLbl text color to theme color, its alignment to center, set background to tableview to noDataLbl. Return no. of items in monthlyBestseller items.
    If type of selection is year, if yealyBestSellerItems in by_DateSelection is not null,
    if count of items in yearlyBestsellerItems is 0, set noDataLbl text to No data found else set noDataLbl text to null.
    Set noDataLbl text color to theme color, its alignment to center, set background to tableview to noDataLbl. Return no. of items in yearlyBestseller items.
    Return 0 in default case.
    */
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
    
    /**
     This method returns no. of rows in section. If status of particular section is opened, if bestSellerData is not null,
     if type is week, if weeklyBestsellerItems in byDateSelection is not null, if item_Details in weeklyBestseller items is not null,
     return no. of items in item_Details+1 including header row. Rajat ji please check this
     If type is month, if monthlyBestsellerItems in byDateSelection is not null, if item_Details in monthlyBestseller items is not null,
     return no. of items in item_Details+1 including header row. 
     If type is year, if yearlyBestsellerItems in byDateSelection is not null, if item_Details in yearlyBestseller items is not null,
     return no. of items in item_Details+1 including header row. 
     Return 1 by default.
    */
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

extension UITableView {
    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
    
    func scrollToTop(animated: Bool) {
        let indexPath = IndexPath(row: 0, section: 0)
        if self.hasRowAtIndexPath(indexPath: indexPath) {
            self.scrollToRow(at: indexPath, at: .top, animated: animated)
        }
    }
}
