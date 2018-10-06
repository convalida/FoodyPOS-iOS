//
//  SalesReportVC.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 04/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit
enum Selection {
    case daily
    case weekly
    case monthly
}

class SalesReportVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgDaily: UIImageView!
    @IBOutlet weak var imgWeekly: UIImageView!
    @IBOutlet weak var imgMonthly: UIImageView!
    @IBOutlet weak var lblDaily: UILabel!
    @IBOutlet weak var lblWeekly: UILabel!
    @IBOutlet weak var lblMonthly: UILabel!
    @IBOutlet weak var btnStartDate: UIButton!
    @IBOutlet weak var btnEndDate: UIButton!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblTotalOrder: UILabel!
    @IBOutlet weak var viewTop: UIView!

    var reportData:Report?
    var selection:Selection = .daily
    var hudView = UIView()
    var isSearch = false
    
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
        
        initHudView()
    }

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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initDate() {
        if !isSearch {
            let lastSun = Date.today().previous(.sunday)
            btnStartDate.setTitle(lastSun.getDateString(), for: .normal)
            btnEndDate.setTitle(Date.todayDate, for: .normal)
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
    
    @IBAction func btnBackDidClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnStartDateDidClicked(_ sender: UIButton) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date.today()
        if let date = Date.getDate(fromString: (sender.titleLabel?.text)!) {
            datePicker.date = date
        }
        Alert.showDatePicker(dataPicker: datePicker, controller: self) { (date) in
            sender.setTitle(date.getDateString(), for: .normal)
        }
    }
    
    @IBAction func btnEndDidClicked(_ sender: UIButton) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date.today()
        if let date = Date.getDate(fromString: (sender.titleLabel?.text)!) {
            datePicker.date = date
        }
        Alert.showDatePicker(dataPicker: datePicker, controller: self) { (date) in
            sender.setTitle(date.getDateString(), for: .normal)
        }
    }
    
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
    
    @IBAction func btnSearchDidClicked(_ sender: UIButton) {
        if Date.getDate(fromString: (self.btnStartDate.titleLabel?.text)!)! <= Date.getDate(fromString: (self.btnEndDate.titleLabel?.text)!)! {
            self.isSearch = true
            self.callReportAPI()
        }else {
            self.showToast("Start date must be less than or equal to end date")
        }
    }
    
    private func setStartDate() {
        if !isSearch {
            let startDate = Date.startOfMonth()
            btnStartDate.setTitle(startDate.getDateString(), for: .normal)
            btnEndDate.setTitle(Date.todayDate, for: .normal)
        }
    }
    
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
