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
    var dashboardData:Dashboard1?

    @IBOutlet weak var btnWeek: UIButton!
    @IBOutlet weak var btnMonth: UIButton!
    @IBOutlet weak var btnYear: UIButton!
    @IBOutlet weak var btnSale: UIButton!
    @IBOutlet weak var btnOrders: UIButton!
    @IBOutlet weak var lblGraph: UILabel!
    @IBOutlet weak var chartView: HIChartView!
    @IBOutlet weak var lblRestaurantName: UILabel!
    @IBOutlet weak var viewTop: UIView!
    
    var xAxisData = [String]()
    var saleData = [Double]()
    var orderData = [Int]()
    var isData = false
    var hudView = UIView()
    
    struct Area {
        static var isAreaOne = true
        static var isAreaTwo = true
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
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
        
        btnSale.isSelected = true
        btnOrders.isSelected = true

        btnWeek.backgroundColor = UIColor.themeColor
        
        if let rsName = UserManager.restaurentName {
            lblRestaurantName.text = rsName
        }else {
            lblRestaurantName.text = ""
        }
        
        initHudView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if dashboardData == nil {
            DispatchQueue.main.async {
                self.callDashboardAPI()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hudView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
    //Initialize the high chart
    func initChart() {
        let options = HIOptions()
        let chart = HIChart()
        chart.type = "areaspline"
        
        chart.zoomType = "x"
        chart.panning = true

        let title = HITitle()
        title.text = ""
        
        let xaxis = HIXAxis()
        xaxis.categories = xAxisData
        if isData {
            xaxis.min = 0.5
        }
        xaxis.startOnTick = false
        xaxis.endOnTick = false
        xaxis.tickInterval = 1
        xaxis.maxPadding = 0
        
        let yaxis = HIYAxis()
        yaxis.title = HITitle()
        yaxis.title.text = ""
        yaxis.min = 0
        if !isData {
            //if no data in chart then set maximum point value of y axis
            yaxis.max = 2
        }
        
        let tooltip = HITooltip()
        tooltip.shared = 1
        tooltip.valueSuffix = " units"
        tooltip.followTouchMove = false
        
        let credits = HICredits()
        credits.enabled = 0
        
        let exporting = HIExporting()
        exporting.enabled = false
        
        let plotoptions = HIPlotOptions()
        plotoptions.areaspline = HIAreaspline()
        plotoptions.areaspline.fillOpacity = 0.5
        plotoptions.areaspline.dataLabels = HIDataLabels()
        plotoptions.areaspline.dataLabels.enabled = true
        
        let series = HISeries()
        plotoptions.series = series
        //plotoptions.series.pointStart = 0
    
        let areaspline1 = HIAreaspline()
        areaspline1.name = "Sales"
        areaspline1.data = saleData
        
        let areaspline2 = HIAreaspline()
        areaspline2.name = "Order"
        areaspline2.data = orderData
//        if !isData {
//            areaspline2.marker = HIMarker()
//            areaspline2.marker.enabled = false
//            areaspline2.dataLabels = HIDataLabels()
//            areaspline2.dataLabels.enabled = false
//            tooltip.followPointer = false
//            tooltip.enabled = false
//            series.enableMouseTracking = false
//            plotoptions.areaspline.events = HIEvents()
//            plotoptions.areaspline.events.legendItemClick = HIFunction(jsFunction: "function() { return false; }")
//        }
        
        options.chart = chart
        options.title = title
        options.xAxis = [xaxis]
        options.yAxis = [yaxis]
        options.tooltip = tooltip
        options.credits = credits
        options.exporting = exporting
        options.plotOptions = plotoptions
        if Area.isAreaOne && Area.isAreaTwo {
            options.series = [areaspline1, areaspline2]
        }else if Area.isAreaOne {
            options.series = [areaspline1]
        }else if Area.isAreaTwo {
            options.series = [areaspline2]
        }else {
            options.series = []
        }
        chartView.options = options
    }
    
    //Initialize chart data when chart load
    func initChartData() {
        isData = false
        xAxisData = []
        saleData = []
        orderData = []
        btnWeek.backgroundColor = UIColor.themeColor
        btnMonth.backgroundColor = UIColor.lightUnselect
        btnYear.backgroundColor = UIColor.lightUnselect
        if let dashboard = dashboardData {
            for week in dashboard.chart.week {
                xAxisData.append(week.weekDay)
                if let sales = Double(week.totalSale) {
                    saleData.append(sales.rounded())
                }
                if let orders = Int(week.totalOrders) {
                    orderData.append(orders)
                }
                isData = true
            }
            xAxisData.append("")
            saleData.append(0.0.rounded())
//            if !isData {
//                orderData.append(1)
//            } else {
                orderData.append(0)
            //}
            xAxisData.reverse()
            saleData.reverse()
            orderData.reverse()
        }
        initChart()
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
        
        let menuItems = [changePassword,logout]
        
        KxMenu.show(in: self.view, from: sender.frame, menuItems: menuItems)
    }
    
    @IBAction func btnTopSaleDidClicked(_ sender: UIButton) {
        showSalesVC()
    }
    
    @IBAction func btnOrderListDidClicked(_ sender: UIButton) {
        showOrderVC()
    }
    
    @IBAction func btnBestSellerDidClicked(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.BestSellerVC) as! BestSellerVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSaleDidClicked(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        }else {
            sender.isSelected = true
        }
        Area.isAreaOne = !Area.isAreaOne
        initChart()
    }
    
    @IBAction func btnOrdersDidClicked(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        }else {
            sender.isSelected = true
        }
        Area.isAreaTwo = !Area.isAreaTwo
        initChart()
    }
    
    @IBAction func btnWeekDidClicked(_ sender: UIButton) {
        if sender.backgroundColor == UIColor.themeColor {
            return
        }
       initChartData()
    }
    
    @IBAction func btnMonthDidClicked(_ sender: UIButton) {
        if sender.backgroundColor == UIColor.themeColor {
            return
        }
        isData = false
        xAxisData = []
        saleData = []
        orderData = []
        btnWeek.backgroundColor = UIColor.lightUnselect
        btnMonth.backgroundColor = UIColor.themeColor
        btnYear.backgroundColor = UIColor.lightUnselect
        if let dashboard = dashboardData {
            for week in dashboard.chart.month {
                xAxisData.append(week.daydate)
                if let sales = Double(week.totalSale) {
                    saleData.append(sales.rounded())
                }
                if let orders = Int(week.totalOrders) {
                    orderData.append(orders)
                }
                isData = true
            }
            xAxisData.append("0")
            saleData.append(0.0.rounded())
            orderData.append(0)
            xAxisData.reverse()
            saleData.reverse()
            orderData.reverse()
        }
        initChart()
    }
    
    @IBAction func btnYearDidClicked(_ sender: UIButton) {
        if sender.backgroundColor == UIColor.themeColor {
            return
        }
        isData = false
        xAxisData = []
        saleData = []
        orderData = []
        btnWeek.backgroundColor = UIColor.lightUnselect
        btnMonth.backgroundColor = UIColor.lightUnselect
        btnYear.backgroundColor = UIColor.themeColor
        if let dashboard = dashboardData {
            for week in dashboard.chart.year {
                xAxisData.append(week.month)
                if let sales = Double(week.totalSale) {
                    saleData.append(sales.rounded())
                }
                if let orders = Int(week.totalOrders) {
                    orderData.append(orders)
                }
                isData = true
            }
            xAxisData.append("")
            saleData.append(0.0.rounded())
            orderData.append(0)
            xAxisData.reverse()
            saleData.reverse()
            orderData.reverse()
        }
        initChart()
    }
    
    //Show all the options when thee dot button pressed
    @objc func pushMenuItem(sender:KxMenuItem) {
        KxMenu.dismiss()
        switch sender.title {
        case "Settings":
            print("Settings")
            
        case "Change Password":
            let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.ChangePasswordVC) as! ChangePasswordVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "Logout":
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
    }
    
    //Method for show sales UI
    private func showSalesVC() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.TopSaleVC) as! TopSaleVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //Method for show order UI
    private func showOrderVC() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.OrderListVC) as! OrderListVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func callDashboardAPI() {
        hudView.isHidden = false
        guard let restaurentId = UserManager.restaurantID else {
            return
        }
        let prameterDic = ["RestaurantId":restaurentId]
        APIClient.dashboard(paramters: prameterDic) { (result) in
            self.hudView.isHidden = true
            switch result {
            case .success(let dashboard):
                self.dashboardData = dashboard
                self.manageData()
                self.initChartData()
                self.reloadTable()
                
            case .failure(let error):
                print(error.localizedDescription)
                self.showToast(AppMessages.msgFailed)
            }
        }
    }
    
    //Initialize starting data
    func manageData() {
        if let dashboard = dashboardData {
            Dashboard.titleArray = [Dashboard.Data(title: "Total Sale", subtitle: dashboard.labelValues.totalSale, icon: #imageLiteral(resourceName: "icon1")),
                                    Dashboard.Data(title: "Weekly Sale", subtitle: dashboard.labelValues.weeksale, icon: #imageLiteral(resourceName: "icon2")),
                                    Dashboard.Data(title: "Total Orders", subtitle: dashboard.labelValues.totalOrders, icon: #imageLiteral(resourceName: "icon3")),
                                    Dashboard.Data(title: "Weekly Orders", subtitle: dashboard.labelValues.weeklyOrder, icon: #imageLiteral(resourceName: "icon4")),
                                    Dashboard.Data(title: "Total Customers", subtitle: dashboard.labelValues.totalCustomers, icon: #imageLiteral(resourceName: "icon5")),
                                    Dashboard.Data(title: "Weekly Customers", subtitle: dashboard.labelValues.weekCustomer, icon: #imageLiteral(resourceName: "icon6"))]
        }
    }
    
    //Reload the table when new data arrive
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension DashboardVC:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSection = 1
        
        let noDataLbl = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
        if let _ = dashboardData {
            tableView.tableFooterView?.isHidden = false
            noDataLbl.text = ""
        }else {
            tableView.tableFooterView?.isHidden = true
            noDataLbl.text = "No data found"
        }
        noDataLbl.textColor = UIColor.themeColor
        noDataLbl.textAlignment = .center
        tableView.backgroundView = noDataLbl
        
        return numberOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = dashboardData {
            return Dashboard.titleArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Dashboard.CellIdentifier.dashboardCell) as? DashboardCell else {
                return DashboardCell()
            }
            let data = Dashboard.titleArray[indexPath.row]
        
            cell.lblTitle.text = data.title
            cell.lblValue.text = data.subtitle
            cell.imgIcon.image = data.icon
            return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if Global.isIpad {
            return 145
        }
        return 115
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        
        case 0,1,2,3:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.SalesReportVC) as! SalesReportVC
            self.navigationController?.pushViewController(vc, animated: true)
  
        case 4,5:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.SalesSellAllVC) as! SalesSellAllVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            print("Default")
        }
    }
}

extension DashboardVC:UITableViewDelegate {

}
