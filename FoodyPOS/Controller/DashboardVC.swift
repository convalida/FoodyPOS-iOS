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
        
        //Set the button default to button select
        btnSale.isSelected = true
        btnOrders.isSelected = true

        //Set the default button background color
        btnWeek.backgroundColor = UIColor.themeColor
        
        //Set the restaurent name
        if let rsName = UserManager.restaurentName {
            lblRestaurantName.text = rsName
        }else {
            lblRestaurantName.text = ""
        }
        
        //initialize the white background hud view
        initHudView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Get dashboard data from server when no data
        if dashboardData == nil {
            DispatchQueue.main.async {
                self.callDashboardAPI()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Initialize the hud view
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
        
        //Set the zoom for x-axis
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
        
        //Initialize the tooltip for show data
        let tooltip = HITooltip()
        tooltip.shared = 1
        tooltip.valuePrefix = "$"
        tooltip.followTouchMove = false
        
        let credits = HICredits()
        credits.enabled = 0
        
        let exporting = HIExporting()
        exporting.enabled = false
        
        //Set plot options to create SPLine
        let plotoptions = HIPlotOptions()
        plotoptions.areaspline = HIAreaspline()
        plotoptions.areaspline.fillOpacity = 0.5
        plotoptions.areaspline.dataLabels = HIDataLabels()
        plotoptions.areaspline.dataLabels.enabled = true
        
        let series = HISeries()
        plotoptions.series = series
    
        //Initialize the first area sales
        let areaspline1 = HIAreaspline()
        areaspline1.name = "Sales"
        areaspline1.data = saleData
        
        //Initialize the second area orders
        let areaspline2 = HIAreaspline()
        areaspline2.name = "Orders"
        areaspline2.data = orderData
        areaspline2.tooltip = HITooltip()
        areaspline2.tooltip.valuePrefix = ""
        
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
                    saleData.append(sales.rounded(toPlaces: 2))
                }
                if let orders = Int(week.totalOrders) {
                    orderData.append(orders)
                }
                isData = true
            }
            xAxisData.append("")
            saleData.append(0.0.rounded(toPlaces: 2))
            orderData.append(0)
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
    
    //Show the options on click option three dot button
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
    
    //Show the top sales data UI
    @IBAction func btnTopSaleDidClicked(_ sender: UIButton) {
        showSalesVC()
    }
    
    //Show the order list data UI
    @IBAction func btnOrderListDidClicked(_ sender: UIButton) {
        showOrderVC()
    }
    
    //Show the best seller data UI
    @IBAction func btnBestSellerDidClicked(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.BestSellerVC) as! BestSellerVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //Show the sales graph
    @IBAction func btnSaleDidClicked(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        }else {
            sender.isSelected = true
        }
        Area.isAreaOne = !Area.isAreaOne
        initChart()
    }
    
    //Show the order graph
    @IBAction func btnOrdersDidClicked(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        }else {
            sender.isSelected = true
        }
        Area.isAreaTwo = !Area.isAreaTwo
        initChart()
    }
    
    //Show the week graph
    @IBAction func btnWeekDidClicked(_ sender: UIButton) {
        if sender.backgroundColor == UIColor.themeColor {
            return
        }
       initChartData()
    }
    
    //Show the month graph
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
                    saleData.append(sales.rounded(toPlaces: 2))
                }
                if let orders = Int(week.totalOrders) {
                    orderData.append(orders)
                }
                isData = true
            }
            xAxisData.append("0")
            saleData.append(0.0.rounded(toPlaces: 2))
            orderData.append(0)
            xAxisData.reverse()
            saleData.reverse()
            orderData.reverse()
        }
        initChart()
    }
    
    //Show the year graph
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
                    saleData.append(sales.rounded(toPlaces: 2))
                }
                if let orders = Int(week.totalOrders) {
                    orderData.append(orders)
                }
                isData = true
            }
            xAxisData.append("")
            saleData.append(0.0.rounded(toPlaces: 2))
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
    
    //Get dashboard data from server
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
                self.showAlert(title: kAppName, message: error.localizedDescription)
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
