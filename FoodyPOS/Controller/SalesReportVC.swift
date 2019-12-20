//
//  SalesReportVC.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 04/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

struct StatusReport{
    var isOpened = Bool()
}

///Enum for daily, weekly and monthly selection
enum Selection {
    ///Case if daily tab was selected
    case daily
    ///Case if weekly tab was selected
    case weekly
    ///Case if monthly tab was selected
    case monthly
}


//struct StatusDetail{
 //   var isOpened = Bool()
//}

/**protocol StatusDetail {
    var isCollapsible: Bool { get }
    var isCollapsed: Bool { get set }
}

extension StatusDetail{
    var isCollapsible: Bool{
        return true
    }
}**/

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

    
    var statusReportData = [StatusReport]()
  //  var statusDetail = [StatusDetail]()
  //  var isCollapsible: Bool { get }
  //  var isCollapsed: Bool { get set }
           var status = StatusReport()
    
    ///Structure for reports instantiated
    var reportData:Report?
    ///Set selection to be daily by default
    var dailyReport:Day?
    var weeklyReport:Week?
    var monthlyReport:Month?
    var dayByDate:ByDate?
    var weekByDate:ByWeekDate?
    var monthByDate:ByMonthDate?
    var selection:Selection = .daily
    ///Instantiate hud view
    var hudView = UIView()
    ///Set isSearch value to false by default
    var isSearch = false
    var sectionCount = 0
    var expandedSectionHeaderNumber: Int = -1
    
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
       
        
        imgDaily.tintAdjustmentMode = .normal
        imgWeekly.tintAdjustmentMode = .normal
        imgMonthly.tintAdjustmentMode = .normal
        
        imgDaily.tintColor = UIColor.themeColor
        imgWeekly.tintColor = UIColor.black
        imgMonthly.tintColor = UIColor.black
        lblDaily.textColor = UIColor.themeColor
        lblWeekly.textColor = UIColor.black
        lblMonthly.textColor = UIColor.black
        
        if reportData == nil {
        callReportAPI()
        }
         
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
    Set date in date picker equal to date in button which is clicked. Show date picker alert and set text in from field equal to alert's date. 
    */
    @IBAction func btnStartDateDidClicked(_ sender: UIButton) {
  /**  if selection == .daily{
            imgDaily.tintColor = UIColor.themeColor
            imgWeekly.tintColor = UIColor.black
            imgMonthly.tintColor = UIColor.black
            lblDaily.textColor = UIColor.themeColor
            lblWeekly.textColor = UIColor.black
            lblMonthly.textColor = UIColor.black
        }**/
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
    Set date in date picker equal to date in button which is clicked. Show date picker alert and set text in from field equal to alert's date.   
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
        //setWeekData()
        selection = .weekly
        imgDaily.tintColor = UIColor.black
        imgWeekly.tintColor = UIColor.themeColor
        imgMonthly.tintColor = UIColor.black
        lblDaily.textColor = UIColor.black
        lblWeekly.textColor = UIColor.themeColor
        lblMonthly.textColor = UIColor.black
        

     //   status.isOpened = false
     //   statusReportData.append(status)
  
        //self.tableView.reloadData()
       // initData()
 //        reloadTable()
       
      /**     if statusReportData.isOpened {
                statusReportData[indexPath.section].isOpened = false
            }
            
            let sections = IndexSet(integer:indexPath.section)
            tableView.reloadSections(sections, with: .none)**/
       // }
        reloadTable()
      //  self.tableView.reloadData()
    }
    
     /**
    Call setStartDate method which sets start date to first date of current month. Call setMonthData which displays total orders and total amount of month.
    Set tint color of weekly image, monthly image, weekly button and monthly button to black. Call reloadTable method to reload the table.
    */
    @IBAction func btnMonthlyDidClicked(_ sender: UIButton) {
        setStartDate()
      //  setMonthData()
        selection = .monthly
        imgDaily.tintColor = UIColor.black
        imgWeekly.tintColor = UIColor.black
        imgMonthly.tintColor = UIColor.themeColor
        lblDaily.textColor = UIColor.black
        lblWeekly.textColor = UIColor.black
        lblMonthly.textColor = UIColor.themeColor
     //   self.tableView.reloadData()
       // tableView.beginUpdates()
     //   tableView.endUpdates()
       // if(statusReportData[].isOpened){
       
       // }
       //  tableViewCollapseSections()
        reloadTable()
    }
    
    func tableViewCollapseSections(){
    print("Collapse all open sections")
       // status.isOpened
        self.expandedSectionHeaderNumber = -1
        status.isOpened = false
      //  var indexesPath = [IndexPath]()
       // NSRange range = NSMakeRange(0, 1)
      //  tableView.reloadSections(NSIndexSet *)sections
       // self.tableView.beginUpdates()
       // self.tableView.endUpdates()
        if let report = reportData{
            if report.month?.count != 0{
             //   let indexSet = NSMutableIndexSet()
              //  indexSet.add(report.month!.count)
             //   tableView.reloadSections(IndexSet indexSet, with )
                let indexSet = IndexSet(integersIn: 0..<report.month!.count)
                self.tableView.reloadData()
                self.tableView.reloadSections(indexSet, with: .fade)

            }
        }
        
    
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
    
    func initData() {
        if let reports = reportData{
            if let dailySection = reports.day{
                /** let date = dailyReport?.byDate
                 for _ in 0...date!.count{
                 var status = StatusReport()
                 status.isOpened = false
                 statusReportData.append(status)
                 }**/
                for _ in 0...dailySection.count{
                    var status = StatusReport()
                    status.isOpened = false
                    statusReportData.append(status)
                    
                }
            }
            if let weeklySection = reports.week{
                for _ in 0...weeklySection.count{
                var status  = StatusReport()
                    status.isOpened = false
                    statusReportData.append(status)
                }
            }
            if let monthlySection = reports.month{
                for _ in 0...monthlySection.count{
                    var status = StatusReport()
                    status.isOpened = false
                    statusReportData.append(status)
                }
            }
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
               self.initData()
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
    Call reloadData method on table view. If no. of rows in section 0 is greater than 0, scroll the view to 0th row of table view or top of table view.
    */
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            if self.tableView.numberOfRows(inSection: 0) > 0 {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .none, animated: true)
            }
        }
      //  initData()
        
    }
    
    /**
    This method calculates total no. of orders, and total amount when daily button is pressed. Initalize total orders and total amount.
    If reports has day data, if orders are not nil, total the no. of orders. If amount is not nil, total the amount of orders and round off to two places.
    Return total no. of orders and total amount rounded to two decimal places.  
    */
    func getDayCount() -> (String, String) {
           var totalOrders = 0
        var totalAmount = 0.0.rounded(toPlaces: 2)
        if let reports = reportData {
            for report in reports.day! {
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

    /**
    This method calculates total no. of orders, and total amount when weekly button is pressed. Initalize total orders and total amount.
    If reports has week data, if orders are not nil, total the no. of orders. If amount is not nil, total the amount of orders and round off to two places.
    Return total no. of orders and total amount rounded to two decimal places.  
    */
    func getWeekCount() -> (String, String) {
        var totalOrders = 0
        var totalAmount = 0.0
        if let reports = reportData {
            for report in reports.week! {
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
    
     /**
    This method calculates total no. of orders, and total amount when monthly button is pressed. Initalize total orders and total amount.
    If reports has month data, if orders are not nil, total the no. of orders. If amount is not nil, total the amount of orders and round off to two places.
    Return total no. of orders and total amount rounded to two decimal places.  
    */
    func getMonthCount() -> (String, String) {
        var totalOrders = 0
        var totalAmount = 0.0
        if let reports = reportData {
            for report in reports.month! {
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
    
     /**
    This method is called, when daily button is clicked and by default when reports are loaded. Call getDayCount method and set total no. of orders and total amount to corresponding text fields.
    */
    func setDayData() {
        let report = getDayCount()
        lblTotalOrder.text = report.0
        lblTotalAmount.text = "$" + report.1
       /** if let dayReports = dailyReport{
            if let date = dayReports.byDate{
                for _ in 0...date.count{
                    var status = StatusReport()
                    status.isOpened = false
                    statusReportData.append(status)
                }
            }
        }**/
        
    
    }
    /**
    This method is called, when weekly button is clicked. Call getWeekCount method and set total no. of orders and total amount to corresponding text fields.
    */
    func setWeekData() {
       // if let reports = reportData{
        let report = getWeekCount()
        lblTotalOrder.text = report.0
        lblTotalAmount.text = "$" + report.1
       /** if let weekReports = weeklyReport{
            if let week = weekReports.byWeekDate{
                for _ in 0...week.count{
                    var status = StatusReport()
                    status.isOpened = false
                    statusReportData.append(status)
                }
            }
        }**/
    }
    
    /**
    This method is called, when monthly button is clicked. Call getDayCount method and set total no. of orders and total amount to corresponding text fields.
    */
    func setMonthData() {
        let report = getMonthCount()
        lblTotalOrder.text = report.0
        lblTotalAmount.text = "$" + report.1
       /** if let monthReports = monthlyReport{
            if let month = monthReports.byMonthDate{
                for _ in 0...month.count{
                    var status = StatusReport()
                    status.isOpened = false
                    statusReportData.append(status)
                }
            }
        }**/
    }

}
extension SalesReportVC:UITableViewDataSource {
    /**
    This method returns no. of sections. Initialized no. of sections to 1. Set width and height of noDataLbl to width and height of table view.
    If daily selection is selected, if reports data has value, and count of days is 0, set noDataLbl text to No daily data found else set noDataLbl text to null. If reportData has nil value, set noDataLbl text to No daily data found.
    If weekly section is selected, if reports data has value, and count of weeks is 0, set noDataLbl text to No weekly data found else set noDataLbl text to null. If reportData has nil value, set noDataLbl text to No weekly data found.
     If monthly section is selected, if reports data has value, and count of months is 0, set noDataLbl text to No onthly data found else set noDataLbl text to null. If reportData has nil value, set noDataLbl text to No monthly data found.
    For noDataLbl, set text color to theme color, text alignment to centre. Set background of table view to noDataLbl. Return no. of sections.     
    */
    func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSection = 1
        
        let noDataLbl = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
        switch selection {
        case .daily:
            if let report = reportData {
                if report.day!.count == 0 {
                    noDataLbl.text = "No daily data found"
                    noDataLbl.textColor = UIColor.themeColor
                    noDataLbl.textAlignment = .center
                    tableView.backgroundView = noDataLbl
                   return 1
                }else {
                    noDataLbl.text = ""
                    noDataLbl.textColor = UIColor.themeColor
                    noDataLbl.textAlignment = .center
                    tableView.backgroundView = noDataLbl
                    return report.day!.count
                }
            }else {
                noDataLbl.text = "No daily data found"
                noDataLbl.textColor = UIColor.themeColor
                noDataLbl.textAlignment = .center
                tableView.backgroundView = noDataLbl
                return numberOfSection
                
            }
        case .weekly:
            if let report = reportData {
                if report.week!.count == 0 {
                    noDataLbl.text = "No weekly data found"
                    noDataLbl.textColor = UIColor.themeColor
                    noDataLbl.textAlignment = .center
                    tableView.backgroundView = noDataLbl
                    return numberOfSection
                }else {
                    noDataLbl.text = ""
                    noDataLbl.textColor = UIColor.themeColor
                    noDataLbl.textAlignment = .center
                    tableView.backgroundView = noDataLbl
                    return report.week!.count
                }
            }else {
                noDataLbl.text = "No weekly data found"
                noDataLbl.textColor = UIColor.themeColor
                noDataLbl.textAlignment = .center
                tableView.backgroundView = noDataLbl
                return numberOfSection
            }
        case .monthly:
            if let report = reportData {
                if report.month!.count == 0 {
                    noDataLbl.text = "No monthly data found"
                    noDataLbl.textColor = UIColor.themeColor
                    noDataLbl.textAlignment = .center
                    tableView.backgroundView = noDataLbl
                    return numberOfSection
                }else {
                    noDataLbl.text = ""
                    noDataLbl.textColor = UIColor.themeColor
                    noDataLbl.textAlignment = .center
                    tableView.backgroundView = noDataLbl
                    return report.month!.count
                }
            }else {
                noDataLbl.text = "No monthly data found"
                noDataLbl.textColor = UIColor.themeColor
                noDataLbl.textAlignment = .center
                tableView.backgroundView = noDataLbl
                return numberOfSection
            }
        }
        noDataLbl.textColor = UIColor.themeColor
        noDataLbl.textAlignment = .center
        tableView.backgroundView = noDataLbl
        
       // tableView(<#T##tableView: UITableView##UITableView#>, numberOfRowsInSection: <#T##Int#>)
        
        return numberOfSection
    }
    
    /**
    This method returns no. of rows in section. If daily button is selected, return count of days in reportData.
    If weekly button is selected, return count of weeks in reportData. If monthly button is selected, return count of months in reportData.
    Return 0 by default.
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selection {
        case .daily:
          //  if (statusReportData[section].isOpened){
        //   print(section)
         //  if(section>0){
          // print (reportData)
                
            if let report = reportData {
                if (statusReportData[section].isOpened){
                if let day = report.day{
                    if(day.count>0){
                    if let date = day[section].byDate{
                        return date.count+1
                    }
                }
                    else{
                    return 0
                    }
                    }
              //  return 0
            }
               return 1
            }
          // }
            return 0
       /** }
           else{
            return 0
            }**/
              //  if (statusReportData[section].isOpened){
                    
               // }
                
                /**    if let  daily = report.day{
                        if let date = daily[section].byDate{
                            return date.count+1
                    }
                }**/
                
          //  }
          //  return 1
                
            //    switch (section){
              //  case 0:
               
                       /** if let dayReport = dailyReport{
                            if let dates = dayReport.byDate{
                              // if (statusDetail[dates].isOpened){
                               // }
                              //  if(dates.)
                               // let date = Day
                              //  if(dates.isCollapsed){
                                    
                                //}
                             //   sectionCount = 2
                                return dates.count+1
                            }
                        }**/
                
                //   }
                
                    
               /** case 1:
                    if(statusData[section].isOpened){
                        
                    }**/
              //  default : 0
                //}
                
                
               /** if let dayReport = dailyReport{
                    if let date = dayReport.byDate{
                        if let orderNumber = date[section].orderDetails{
                            return orderNumber.count+1
                        }
                    }
                }**/
            
        case .weekly:
            print(section)
           
            if let report = reportData {
             /**   if(statusData[section].isOpened){
                    if let weekReport = weeklyReport{
                        if let weeks = weekReport.byWeekDate{
                            return weeks.count+1
                        }
                    }
                }**/
                if let week = report.week{
                     if(statusReportData[section].isOpened){
                       // self.expandedSectionHeaderNumber=section
                    if let date = week[section].byWeekDate{
                    return date.count+1
                    }
                }
                   /**  else{
                       // cell.imgGrandparent.transform = CGAffineTransform.identity
                    return 1
                    }**/
             //   return report.week!.count
                }
            }
          /**  else{
                if let report = reportData{
                    if let week = report.week{
                    return week.count
                    }
                }
            }**/
            return 1
        case .monthly:
          //  if let report = reportData {
            
                    if let report = reportData{
                   // if let monthReport = monthlyReport{
                        if let months = report.month{
                            if(statusReportData[section].isOpened){
                           //     self.expandedSectionHeaderNumber=section
                            if let date = months[section].byMonthDate{
                            return date.count+1
                        }
                    }
                         /**   else{
                                if(self.expandedSectionHeaderNumber == -1){
                            return 0
                                }
                            }**/
              //  }
                //return report.month!.count
            }
        }
        return 1
    }
    }
    /**
    This method asks the data source for a cell to insert in a particular location of the table view. Set cell to SalesReportCell if cell identifier is salesReportCell, else set cell to an empty SalesReportCell (this happens very rarely).
    If daily was selected, if reportData has data, for each row index in daily, set order count and amount rounded to 2 decimal places in corresponding text field. In case of single order, the concatenated string is order else orders.
    If weekly was selected, if reportData has data, for each row index in weekly, set order count and amount rounded to 2 decimal places in corresponding text field. 
    If monthly was selected, if reportData has data, for each row index in monthly, set order count and amount rounded to 2 decimal places in corresponding text field. 
    Return the cell.
    */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // if(!status.isOpened){
          // let indexPath.init(row: <#T##Int#>, section: <#T##Int#>)
       // }
        if(indexPath.row == 0){
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "salesReportGrandCell") as? SalesReportCell else {
            return SalesReportCell()
        }
        switch selection {
        case .daily:
            if let report = reportData {
              //  if let dayReport = dailyReport{
                if let day = report.day{
                    if(day.count>0){
                    if statusReportData[indexPath.section].isOpened{
                    cell.imgGrandparent.transform = CGAffineTransform(rotationAngle: .pi)
                    }
                    else{
                    cell.imgGrandparent.transform = CGAffineTransform.identity
                    }
                
                let day = report.day![indexPath.section]
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
                    else{
                    return SalesReportCell()
                    }
            }
                
            }
        case .weekly:
            if let report = reportData {
              /**  let week = report.week![indexPath.row]
                cell.lblDay.text = week.week
                cell.lblOrder.text = week.totalsOrders + " orders"
                if let amt = Double(week.totalsales) {
                    cell.lblPrice.text = "$" + "\(amt.rounded(toPlaces: 2))"
                }**/
                if let week = report.week{
                    if(statusReportData[indexPath.section].isOpened){
                        cell.imgGrandparent.transform = CGAffineTransform(rotationAngle: .pi)
                    }
                    else{
                    cell.imgGrandparent.transform = CGAffineTransform.identity
                    }
                    let week = report.week![indexPath.section]
                    cell.lblDay.text = week.week
                    cell.lblOrder.text = week.totalsOrders + " orders"
                    if let amt = Double(week.totalsales) {
                        cell.lblPrice.text = "$" + "\(amt.rounded(toPlaces: 2))"
                    }
                }
            }
        case .monthly:
            if let report = reportData {
                if let month = report.month{
                    if(statusReportData[indexPath.section].isOpened){
                    cell.imgGrandparent.transform = CGAffineTransform(rotationAngle: .pi)
                    }
                    else{
                    cell.imgGrandparent.transform = CGAffineTransform.identity
                    }
                let month = report.month![indexPath.section]
                cell.lblDay.text = month.month
                cell.lblOrder.text = month.totalsOrders + " orders"
                if let amt = Double(month.totalsales) {
                    cell.lblPrice.text = "$" + "\(amt.rounded(toPlaces: 2))"
                }
            }
            }
        }
        return cell
    }
        
     //   else if (indexPath.row == 1){
        else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "salesReportParentCell") as? SalesReportCell else{
                return SalesReportCell()
            }
           /** switch selection {
            case .daily:
                if let report = reportData{
                    if let day = report.day{
                       // if let dayByDate = day.
                        
                }
            case .weekly:
            }**/
            if let reports = reportData{
                switch selection{
                case .daily:
                    if let daily = reports.day{
                       // if statusReportData[indexPath.section].isOpened{
                       // cell.imgHeader.transform = CGAffineTransform(rotationAngle: .pi)
                        //}
                        //else{
                       // cell.imgHeader.transform = CGAffineTransform.identity
                        //}
                        if let dates = daily[indexPath.section].byDate{
                            //if let date = dates[indexPath.row-1].o
                      //      if statusReportData[indexPath.section].isOpened{
                                cell.imgHeader.transform = CGAffineTransform(rotationAngle: .pi)
                        //    }
                          //  else{
                            cell.imgHeader.transform = CGAffineTransform.identity
                           // }
                            if let date = dates[indexPath.row-1].orderDate{
                            cell.lblHeaderDate.text = date
                            }
                            if let amount = dates[indexPath.row-1].totalSales{
                            cell.lblHeaderPrice.text = "$" + amount
                            }
                            if let numOfOrders = dates[indexPath.row-1].totalOrders{
                            cell.lblHeaderOrder.text = numOfOrders + " order(s)"
                            }
                        }
                    }
                case .weekly:
                    if let weekly = reports.week{
                        if let weekDates = weekly[indexPath.section].byWeekDate{
                        cell.imgHeader.transform = CGAffineTransform.identity
                            if let weekDate = weekDates[indexPath.row-1].orderDate{
                            cell.lblHeaderDate.text = weekDate
                            }
                            if let amount = weekDates[indexPath.row-1].totalSales{
                            cell.lblHeaderPrice.text = "$" + amount
                            }
                            if let numberOfOrders = weekDates[indexPath.row-1].totalOrders{
                            cell.lblHeaderOrder.text = numberOfOrders + " order(s)"
                            }
                        }
                    }
                case .monthly:
                    if let monthly = reports.month{
                        if let monthDates = monthly[indexPath.section].byMonthDate{
                        cell.imgHeader.transform = CGAffineTransform.identity
                            if let monthDate = monthDates[indexPath.row-1].orderDate{
                            cell.lblHeaderDate.text = monthDate
                            }
                            if let amount = monthDates[indexPath.row-1].totalSales{
                            cell.lblHeaderPrice.text = "$" + amount
                            }
                            if let numberOfOrders = monthDates[indexPath.row-1].totalOrders{
                            cell.lblHeaderOrder.text = numberOfOrders + " order(s)"
                            }
                        }
                    }
            }
        // return cell
        }
            return cell
    }
        /**else{
            return
        }**/
  //return SalesReportCell()
}
}
extension SalesReportVC:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            if statusReportData[indexPath.section].isOpened {
            statusReportData[indexPath.section].isOpened = false
            }
            else{
            statusReportData[indexPath.section].isOpened = true
            }
            let sections = IndexSet(integer:indexPath.section)
            tableView.reloadSections(sections, with: .none)
        }
        else{
          /**  if statusReportData[indexPath.section].isOpened {
                statusReportData[indexPath.section].isOpened = false
            }
            else{
                statusReportData[indexPath.section].isOpened = true
            }**/
        }
    }
    
    /**
     Asks the delegate for the height to use for a row in a specified location. If device is iPad, return height 140 else return 90
    */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if Global.isIpad {
            return 90.0
        }
        return 70.0
    }

  /**  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 25))
        sectionView.backgroundColor = UIColor.magenta
        
        let sectionName = UILabel(frame: CGRect(x: 5, y: 0, width: tableView.frame.size.width, height: 25))
        //sectionName.text = titleString[section]
        sectionName.textColor = UIColor.white
        sectionName.font = UIFont.systemFont(ofSize: 14)
        sectionName.textAlignment = .left
        
        sectionView.addSubview(sectionName)
        return sectionView

    }**/
}
