//
//  SalesReportVC.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 04/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit
///Enum for daily, weekly and monthly selection
enum Selection {
    ///Case if daily tab was selected
    case daily
    ///Case if weekly tab was selected
    case weekly
    ///Case if monthly tab was selected
    case monthly
}

///Class for sales report view controller
class SalesReportVC: UIViewController {

    ///Outlet for table view
    @IBOutlet weak var tableView: UITableView!
    ///Outlet for daily image view
    @IBOutlet weak var imgDaily: UIImageView!
    ///Outlet for weeky image view
    @IBOutlet weak var imgWeekly: UIImageView!
    ///Outlet for monthly image view 
    @IBOutlet weak var imgMonthly: UIImageView!
    ///Outlet for daily label
    @IBOutlet weak var lblDaily: UILabel!
    ///Outlet for weekly label
    @IBOutlet weak var lblWeekly: UILabel!
    ///Outlet for monthly label
    @IBOutlet weak var lblMonthly: UILabel!
    ///Outlet for start date
    @IBOutlet weak var btnStartDate: UIButton!
    ///Outlet for end date
    @IBOutlet weak var btnEndDate: UIButton!
    ///Outlet for total amount text
    @IBOutlet weak var lblTotalAmount: UILabel!
    ///Outlet for total orders text
    @IBOutlet weak var lblTotalOrder: UILabel!
    ///Outlet for top view or navigation bar
    @IBOutlet weak var viewTop: UIView!

    ///Structure for reports instantiated
    var reportData:Report?
    ///Set selection to be daily by default
    var selection:Selection = .daily
    ///Instantiate hud view
    var hudView = UIView()
    ///Set isSearch value to false by default
    var isSearch = false
    
    ///Set status bar to visible
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
     ///Set light content of status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /**
    Life cycle method called after view is loaded. Set data source and delegate of table view to self. Call initHudView and callSalesAPI method
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        initHudView()
    }

    /**
     Called before the view is loaded. Call initDate method. Set tint color of daily image and daily label to theme color.
     Set tint color of weekly image, monthly image, weekly button and monthly button to black. Call callReportAPI method.
    */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initDate()
        
        imgDaily.tintColor = UIColor.themeColor
        imgWeekly.tintColor = UIColor.black
        imgMonthly.tintColor = UIColor.black
        lblDaily.textColor = UIColor.themeColor
        lblWeekly.textColor = UIColor.black
        lblMonthly.textColor = UIColor.black
        
        callReportAPI()
    }
    
    ///Sent to the view controller when the app receives a memory warning.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   /**
   Called inside viewWillAppear, daily button clicked. If isSearch value is false, set start date to Monday of current week by finding previous occurance of Monday considering today's date and end date to today's date.
   */ 
    func initDate() {
        if !isSearch {
            let lastSun = Date.today().previous(.monday)
            btnStartDate.setTitle(lastSun.getDateString(), for: .normal)
            btnEndDate.setTitle(Date.todayDate, for: .normal)
        }
    }
    
    /**
    Initialize hud. Set background color to white and hud view as sub view. Set constraints to top, left, bottom and right of hud view, add hud view and hide it.
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
    Start date button clicked. Instantiate DatePicker. Set date picker mode to date. Set maximum date of datepicker to today's date. 
    Set date in date picker to date passed in from string. Show date picker alert and set text in from field equal to alert's date. 
    */
    @IBAction func btnStartDateDidClicked(_ sender: UIButton) {
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
    End sate button clicked. Instantiate DatePicker. Set date picker mode to date. Set maximum date of datepicker to today's date. 
    Set date in date picker to date passed in from string. Show date picker alert and set text in from field equal to alert's date.   
    */
    @IBAction func btnEndDidClicked(_ sender: UIButton) {
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
    Daily button was clicked. It is used to show daily reports. Call initDate method to initialize dates to Monday of current week. 
    Call setDayData method which displays total orders and total amount. Set selection value to daily.
    Set tint color of weekly image, monthly image, weekly button and monthly button to black. Call reloadTable method to reload the table.
    */
    @IBAction func btnDailyDidClicked(_ sender: UIButton) {
        initDate()
        setDayData()
        selection = .daily
        imgDaily.tintColor = UIColor.themeColor
        imgWeekly.tintColor = UIColor.black
        imgMonthly.tintColor = UIColor.black
        lblDaily.textColor = UIColor.themeColor
        lblWeekly.textColor = UIColor.black
        lblMonthly.textColor = UIColor.black
        reloadTable()
    }
    
    /**
    Call setStartDate method which sets start date to first date of current month. Call setWeekData which displays total orders and total amount.
    Set tint color of weekly image, monthly image, weekly button and monthly button to black. Call reloadTable method to reload the table.
    */
    @IBAction func btnWeeklyDidClicked(_ sender: UIButton) {
        setStartDate()
        setWeekData()
        selection = .weekly
        imgDaily.tintColor = UIColor.black
        imgWeekly.tintColor = UIColor.themeColor
        imgMonthly.tintColor = UIColor.black
        lblDaily.textColor = UIColor.black
        lblWeekly.textColor = UIColor.themeColor
        lblMonthly.textColor = UIColor.black
        reloadTable()
    }
    
     /**
    Call setStartDate method which sets start date to first date of current month. Call setMonthData which displays total orders and total amount of month.
    Set tint color of weekly image, monthly image, weekly button and monthly button to black. Call reloadTable method to reload the table.
    */
    @IBAction func btnMonthlyDidClicked(_ sender: UIButton) {
        setStartDate()
        setMonthData()
        selection = .monthly
        imgDaily.tintColor = UIColor.black
        imgWeekly.tintColor = UIColor.black
        imgMonthly.tintColor = UIColor.themeColor
        lblDaily.textColor = UIColor.black
        lblWeekly.textColor = UIColor.black
        lblMonthly.textColor = UIColor.themeColor
        reloadTable()
    }

    /**
    Search button clicked. If date in btnStartDate is less than or equal to date in btnEndDate. Set isSearch to true. Call method callReportAPI method.
    If date in btnStartDate is greater than date in btnEndDate, show toast message Start date must be less than or equal to end date
    */    
    @IBAction func btnSearchDidClicked(_ sender: UIButton) {
        if Date.getDate(fromString: (self.btnStartDate.titleLabel?.text)!)! <= Date.getDate(fromString: (self.btnEndDate.titleLabel?.text)!)! {
            self.isSearch = true
            self.callReportAPI()
        }else {
            self.showToast("Start date must be less than or equal to end date")
        }
    }
    
    /**
    Called when weekly or monthly section is clicked. If isSearch value is false, i.e., search button has not been clicked yet.
    Set start date to first date of current month. Set end date to today's date
    */
    private func setStartDate() {
        if !isSearch {
            let startDate = Date.startOfMonth()
            btnStartDate.setTitle(startDate.getDateString(), for: .normal)
            btnEndDate.setTitle(Date.todayDate, for: .normal)
        }
    }
    
    /**
    If restaurant id is not null in UserManager, return. If isSearch value is true, i.e., search button is clicked, parameters will contain
    restaurant id from UserManager, fromDate from btnStartDate text, endDate from btnEndDate text.
    If isSearch value is false, i.e., search button is not clicked, i.e., by default, parameters will contain restaurant id from UserManager, start date and ens date parameters as null.
    Display hud view. Pass paramters to ApiClient class. Hide hud view. If api hit is successful, set response to reportData. Call setDayData method which sets total orders and total amount of days.
    Call reloadtable method which reloads the data. If api hit is not successful, if error message is noDataMessage or noDataMessage1 in Constants.swift, display message msgFailed in AppMessages.swift in dialog else display error message in dialog.
    */
    private func callReportAPI() {
        guard let restaurentId = UserManager.restaurantID else {
            return
        }
        var prameterDic = [String:Any]()
        
        if isSearch {
            prameterDic = ["RestaurantId":restaurentId,
                           "fromdate":(btnStartDate.titleLabel?.text)!,
                           "enddate":(btnEndDate.titleLabel?.text)!]
        }else {
            prameterDic = ["RestaurantId":restaurentId,
                           "fromdate":"null".replacingOccurrences(of: "\"", with: ""),
                           "enddate":"null".replacingOccurrences(of: "\"", with: "")]
        }
        
        self.hudView.isHidden = false
        APIClient.report(paramters: prameterDic) { (result) in
            self.hudView.isHidden = true
            switch result {
            case .success(let report):
                self.reportData = report
                self.setDayData()
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
    Call reloadData method on table view. If no. of rows in section 0 is greater than 0, scroll the view to 0th row of table view. This scrolls to the top of table view.
    */
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            if self.tableView.numberOfRows(inSection: 0) > 0 {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .none, animated: true)
            }
        }
    }
    
    func getDayCount() -> (String, String) {
           var totalOrders = 0
        var totalAmount = 0.0.rounded(toPlaces: 2)
        if let reports = reportData {
            for report in reports.day {
                if let order = Int(report.totalsOrders) {
                    totalOrders = totalOrders + order
                }
                if let amount = Double(report.totalsales) {
                    totalAmount = totalAmount + amount.rounded(toPlaces: 2)
                }
            }
        }
        return ("\(totalOrders)","\(totalAmount.rounded(toPlaces: 2))")
    }
    
    func getWeekCount() -> (String, String) {
        var totalOrders = 0
        var totalAmount = 0.0
        if let reports = reportData {
            for report in reports.week {
                if let order = Int(report.totalsOrders) {
                    totalOrders = totalOrders + order
                }
                if let amount = Double(report.totalsales) {
                    totalAmount = totalAmount + amount.rounded(toPlaces: 2)
                }
            }
        }
        return ("\(totalOrders)","\(totalAmount.rounded(toPlaces: 2))")
    }
    
    func getMonthCount() -> (String, String) {
        var totalOrders = 0
        var totalAmount = 0.0
        if let reports = reportData {
            for report in reports.month {
                if let order = Int(report.totalsOrders) {
                    totalOrders = totalOrders + order
                }
                if let amount = Double(report.totalsales) {
                    totalAmount = totalAmount + amount.rounded(toPlaces: 2)
                }
            }
        }
        return ("\(totalOrders)","\(totalAmount.rounded(toPlaces: 2))")
    }
    
    func setDayData() {
        let report = getDayCount()
        lblTotalOrder.text = report.0
        lblTotalAmount.text = "$" + report.1
    }
    
    func setWeekData() {
        let report = getWeekCount()
        lblTotalOrder.text = report.0
        lblTotalAmount.text = "$" + report.1
    }
    
    func setMonthData() {
        let report = getMonthCount()
        lblTotalOrder.text = report.0
        lblTotalAmount.text = "$" + report.1
    }
}

extension SalesReportVC:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSection = 1
        
        let noDataLbl = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
        switch selection {
        case .daily:
            if let report = reportData {
                if report.day.count == 0 {
                    noDataLbl.text = "No daily data found"
                }else {
                    noDataLbl.text = ""
                }
            }else {
                noDataLbl.text = "No daily data found"
            }
        case .weekly:
            if let report = reportData {
                if report.week.count == 0 {
                    noDataLbl.text = "No weekly data found"
                }else {
                    noDataLbl.text = ""
                }
            }else {
                noDataLbl.text = "No weekly data found"
            }
        case .monthly:
            if let report = reportData {
                if report.month.count == 0 {
                    noDataLbl.text = "No monthly data found"
                }else {
                    noDataLbl.text = ""
                }
            }else {
                noDataLbl.text = "No monthly data found"
            }
        }
        noDataLbl.textColor = UIColor.themeColor
        noDataLbl.textAlignment = .center
        tableView.backgroundView = noDataLbl
        
        return numberOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selection {
        case .daily:
            if let report = reportData {
                return report.day.count
            }
        case .weekly:
            if let report = reportData {
                return report.week.count
            }
        case .monthly:
            if let report = reportData {
                return report.month.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "salesReportCell") as? SalesReportCell else {
            return SalesReportCell()
        }
        switch selection {
        case .daily:
            if let report = reportData {
                let day = report.day[indexPath.row]
                cell.lblDay.text = day.day
                if day.totalsOrders == "1" {
                    cell.lblOrder.text = day.totalsOrders + " order"
                }else {
                    cell.lblOrder.text = day.totalsOrders + " orders"
                }
                if let amt = Double(day.totalsales) {
                    cell.lblPrice.text = "$" + "\(amt.rounded(toPlaces: 2))"
                }
            }
        case .weekly:
            if let report = reportData {
                let week = report.week[indexPath.row]
                cell.lblDay.text = week.week
                cell.lblOrder.text = week.totalsOrders + " orders"
                if let amt = Double(week.totalsales) {
                    cell.lblPrice.text = "$" + "\(amt.rounded(toPlaces: 2))"
                }
            }
        case .monthly:
            if let report = reportData {
                let month = report.month[indexPath.row]
                cell.lblDay.text = month.month
                cell.lblOrder.text = month.totalsOrders + " orders"
                if let amt = Double(month.totalsales) {
                    cell.lblPrice.text = "$" + "\(amt.rounded(toPlaces: 2))"
                }
            }
        }
        return cell
    }
}

extension SalesReportVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if Global.isIpad {
            return 140.0
        }
        return 90.0
    }
}
