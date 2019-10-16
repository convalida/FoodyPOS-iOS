//
//  DashboardVC.swift
//  FoodyPOS
//
//  Created by rajat on 28/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit
import Highcharts

///Class for dashboard view controller
class DashboardVC: UIViewController {

    ///Outlet for table view
    @IBOutlet weak var tableView: UITableView!
    ///Instantaite LeftSlideMenu class
    var leftSlideMenu:LeftSlideMenu!
    ///Instantiate Dashboard1 structure with label values and chart array values
    var dashboardData:Dashboard1?
    var salesData:Sale?

    ///Outlet for week button of graph
    @IBOutlet weak var btnWeek: UIButton!
    ///Outlet for month button of graph
    @IBOutlet weak var btnMonth: UIButton!
    ///Outlet for year button of graph
    @IBOutlet weak var btnYear: UIButton!
    ///Outlet for sale button (check box) of graph
    @IBOutlet weak var btnSale: UIButton!
    ///Outlet for orders button (check box) of graph
    @IBOutlet weak var btnOrders: UIButton!
    ///Outlet for Earning graph text
    @IBOutlet weak var lblGraph: UILabel!
    ///Outlet for chart view
    @IBOutlet weak var chartView: HIChartView!
    ///Outlet for restaurant name text
    @IBOutlet weak var lblRestaurantName: UILabel!
    ///Outlet for action bar
    @IBOutlet weak var viewTop: UIView!
    
    ///Instantiate array for x axis values of graph
    var xAxisData = [String]()
    ///Instantiate array for sales data of graph
    var saleData = [Double]()
    ///Instantiate array of orders data of graph
    var orderData = [Int]()
    ///Initialize boolean indicating if graph has data
    var isData = false
    ///Instantiate hud view
    var hudView = UIView()
    
    ///Struct defination for Sales and Orders Area on graph
    struct Area {
        ///Initalize isAreaOne to true indicating sales area in graph to show sales in graph
        static var isAreaOne = true
          ///Initalize isAreaTwo to true indicating orders area in graph to show orders in graph
        static var isAreaTwo = true
    }

    ///Display status bar
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    ///Set light color of status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: ---------View Life Cycle---------
    /**
     Life cycle method called after view is loaded. Set data source and delegate of table view to self. Initialize LeftSlideMenu class with view controller parameter. Enable left gesture by call enableLeftGesture method of LeftSlideMenu class. Set sale button and order button to be selected by default. Set week button background color to theme color. If UserManager class has restaurentName, then set text to that restaurant name else set set restaurant name text to null. Initalize hud view
     */
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
        } else {
            lblRestaurantName.text = ""
        }
        
        //initialize the white background hud view
        initHudView()
    }

      /**
 Called before the view is loaded. If dashboard does not have label values and graph values call callDashboardAPI method
 */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Get dashboard data from server when no data
        if dashboardData == nil {
            // Call API on main thread
            DispatchQueue.main.async {
                self.callDashboardAPI()
            }
        }
    }
    
///Notifies the view controller that its view was added to a view hierarchy.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    ///Dispose off any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
 Initialize the hud view with white background, add constraints from all sides. Add the hud view and hide the hud view
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
    
    //Initialize the high chart
    /**
     Initialize chart of type areaspline with general options for chart. Set zoom for x-axis. Set panning (dragging) in chart to true. Instantiate title for chart and set text to null. Instantiate x axis values and set values from xAxisData array. If graph has data, set the minimum value of x axis to 0.5 (to start graph from 0 of x axis). Do not force x axis to start and end on tick (at an interval). Set interval of the tick marks in axis units. Set padding of the max value relative to the length of the x-axis. Instantiate Y axis of chart. Instantate chart's main axis and set text in title as null. Set minimum value of y axis to 0. If there is no data in chart, set maximum point value of y axis to 2 (to display of graph at 0 of y axis).
     Initialize tootip (a form of box on user interface that appears when pointed at a value of chart showing orders and sales of that day). The tooltip is shared, the entire plot area will capture mouse movement or touch events. Prefix each value of y axis with $ (later for orders, it is set to null). Tooltip should not follow the finger as it moves on a touch device. Instantiate high chart credits. Highchart by default puts a credits label in the lower right corner of the chart and set enabled credits to 0. Initialize HIExpeorting. Options for the exporting module. Set it to be disabled. Instantiate HIPlotOptions which is is a wrapper object for config objects for each series type to instantiate plot options. Instantiate HIAreaspline, set opacity to 0.5. Instantiate HIDataLabels - options for the series data labels, appearing next to each data point and set it enabled. Instantiate HISeries and set series which are general options for all series types. Initailize first area of graph as Sale, set its text to Sale and set data to saleData array. Initailize second area of graph as Orders, set its text to Orders and set data to orderData array. Instantaite tooltip for second area and set prefix for its y value as null. Set chart, title, tooltip, x axis values, y axis values, tooltip, credits, exporting and plot options for chart. If isAreaOne and isAreaTwo is true (true by default), show both sales and orders graph. If isAreaOne is true, set Sales graph. If isAreaTwo is true, set Orders graph. If isAreaOne and isAreaTwo is false, set empty graph and set the options on chart.
     */
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
        
        // To fix starting point of charts
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
        } else if Area.isAreaOne {
            options.series = [areaspline1]
        } else if Area.isAreaTwo {
            options.series = [areaspline2]
        }else {
            options.series = []
        }
        chartView.options = options
    }
    
    /**
     Initialize weekly chart data when chart loaded first time. Set value of isData to false by default. Initialize x axis data, saleData and orderData array. Set background color of week button to theme color and background color of month button and year button to greyish color. If dashboard has label values and chart values put week array's value in week and append week day values in xAxisData array values, if week has sales value set week's sale values to saleData array values rounded to 2 decimal places. If week has orders values, set week's orders values to orderData array rounded to 2 decimal places. Append x axis data array to empty string values, saleData array values to 0.0 to round off to 2 places and order data array to 0 to fix some graph issues. Reverse the values of xAxisData, saleData and orderData arrayas value passed in json are in opposite order to displayed values and initalize the chart.
     */
    func initWeeklyChart() {
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
            
            // Patches to fix graph issues
            xAxisData.append("")
            saleData.append(0.0.rounded(toPlaces: 2))
            orderData.append(0)
            
            xAxisData.reverse()
            saleData.reverse()
            orderData.reverse()
        }
        // show chart
        initChart()
    }
    
    //MARK: ---------Button actions---------
///When menu button is clicked, call open method of LeftSlideMenu
    @IBAction func btnMenuDidClicked(_ sender: UIButton) {
        leftSlideMenu.open()
    }
    
    //Show the options on click option three dot button.
    /**
 On click option button (three dot button). Using KxMenu library, display text Change Password, Logout text, token text (temprarily), image null, target self, call pushMenuItem method on selection and set text color to black. Push the values to menu items array and display them.
     */
    @IBAction func btnOptionsDidClicked(_ sender: UIButton) {
      /**  let settings = KxMenuItem.init("Token", image: nil, target: self, action: #selector(pushMenuItem(sender:)))
        settings?.foreColor = UIColor.black**/
        
        let changePassword = KxMenuItem.init("Change Password", image: nil, target: self, action: #selector(pushMenuItem(sender:)))
        changePassword?.foreColor = UIColor.black
        
        let logout = KxMenuItem.init("Logout", image: nil, target: self, action: #selector(pushMenuItem(sender:)))
        logout?.foreColor = UIColor.black
        
        let menuItems = [changePassword,logout]
        
        KxMenu.show(in: self.view, from: sender.frame, menuItems: menuItems)
    }
    
    //Show the top sales data UI
    /**
 Top sale button clicked. Call showSalesVC method which instantiates TopSaleVC
     */
    @IBAction func btnTopSaleDidClicked(_ sender: UIButton) {
        showSalesVC()
    }
    
    //Show the order list data UI
    /**
 Orderlist button clicked. Call showOrderVC method which instantiates OrderListVC
     */
    @IBAction func btnOrderListDidClicked(_ sender: UIButton) {
        showOrderVC()
    }
    
    //Show the best seller data UI
    /**
 Bestseller button clicked. Instantiate Bestseller vc and push the vc
     */
    @IBAction func btnBestSellerDidClicked(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.BestSellerVC) as! BestSellerVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //Show the sales graph
    /**
     Sale button (check box) on graph is clicked. If it was checked by default, set it to unchecked else set it to checked. Toggle the value of Sales Chart (i.e., if graph is showing sales data, hide it, if it is visble, hide it) when user click on Sales Checkbox and initialize the chart.
     */
    @IBAction func btnSaleDidClicked(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
        ///The below line is to toggle the value of Sales Chart when user click on Sales button
        Area.isAreaOne = !Area.isAreaOne
        initChart()
    }
    
    //Show the order graph
    /**
     Orders button (check box) on graph is clicked. If it was checked by default, set it to unchecked else set it to checked. Toggle the value of Orders Chart, (i.e., if graph is showing orders data, hide it, if it is visble, hide it) when user click on Orders Checkbox and initialize the chart.
     */
    @IBAction func btnOrdersDidClicked(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
        Area.isAreaTwo = !Area.isAreaTwo
        initChart()
    }
    
    //Show the week graph
    /**
 Week button on graph clicked. If background color of button is theme color, return. Call initWeeklyChart method which shows week graph
     */
    @IBAction func btnWeekDidClicked(_ sender: UIButton) {
        if sender.backgroundColor == UIColor.themeColor {
            return
        }
       initWeeklyChart()
    }
    
    //Show the month graph
    /**
 Month button clicked. If background color of month button is theme color, then return. Set boolean isData value to false. Initalize xAxisData, saleData and orderData array. Set background color of of month button to theme color. Set week button and year button to greyish color to show as unselected.  If dashboard has label values and chart values, put month array's value in week and append week's daydate (month) values in xAxisData array values, if week (month in this case) has sales value set week's (month's) sale values to saleData array values rounded to 2 decimal places. If week has orders values, set week's orders values to orderData array rounded to 2 decimal places. Set isData to true. Append x axis data array to empty string values, saleData array values to 0.0 to round off to 2 places and order data array to 0 to fix some graph issues. Reverse the values of xAxisData, saleData and orderData arrayas value passed in json are in opposite order to displayed values and initalize the chart.
     */
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
        // show chart
        initChart()
    }
    
    //Show the year graph
    /**
     Year button clicked. If background color of year button is theme color, then return. Set boolean isData value to false. Initalize xAxisData, saleData and orderData array. Set background color of of year button to theme color. Set week button and month button to greyish color to show as unselected.
     If dashboard has label values and chart values, put year array's value in week and append week's month (year) values in xAxisData array values, if week (year in this case) has sales value set week's (year's) sale values to saleData array values rounded to 2 decimal places. If week (year) has orders values, set week's (year's) orders values to orderData array rounded to 2 decimal places. Set isData to true. Append x axis data array to empty string values, saleData array values to 0.0 to round off to 2 places and order data array to 0 to fix some graph issues. Reverse the values of xAxisData, saleData and orderData arrayas value passed in json are in opposite order to displayed values and initalize the chart.
     */
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
    
    /// Show all the options when three dot button pressed
    /**
     This method is called when user selects an item from menu (three dots). Firstly, clear the menu.
     If token value is selected, if UserManager class has token value, show alert with title app name, message as token value and action title as copy. Create object of UIPasteboard which is a pre defined class which helps a user share data from one place to another within your app, and from your app to other apps and set token value as string of pasteboard object. This will be removed in final verion of app.
     If Change Password is selected, instantitate ChangePasswordVC and push the VC.
     If Logout was selected, if UserManager class has token value, fetch that value and after trimming it, if it returns null string, display in toast a message that user is looged out. If isRemember value in UserManager class is true, then set isLogin value in UserManager class to false and display root view controller with identifier LoginVC. If isRemember value in UserManager class is false, call flushUserDefaults method in Global class which clears all user default data. Instantaite LoginVC and push vc. Return in both cases if isRemember value is UserManager is true or false. The same steps are followed in case UserManager class does not has token value.
     Take token from UserManager class, and assign it deviceId parameter. Display hud view. Call logout method in APIClient class. If api hit is successful and result code is 1, if isRemember value in UserManager class is true, then set isLogin value in UserManager class to false and display root view controller with identifier LoginVC. If isRemember value in UserManager class is false, call flushUserDefaults method in Global class which clears all user default data. Instantaite LoginVC and push vc. If result code is not 1, display message in response in toast. If api hit is not successful, if error message is noDataMessage or noDataMessage1 in Constants.swift, display message msgFailed in AppMessages.swift in dialog else display error message in dialog.
     In default case, print default in logs.
 */
    @objc func pushMenuItem(sender:KxMenuItem) {
        KxMenu.dismiss()
        switch sender.title {
        /**case "Token":
            if let token = UserManager.token {
                Alert.showSingleButtonAlert(title: kAppName, message: token, actionTitle: "Copy", controller: self) {
                    let pasteboard = UIPasteboard.general
                    pasteboard.string = token
                }
            }**/
        case "Change Password":
            let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.ChangePasswordVC) as! ChangePasswordVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "Logout":
            if let token = UserManager.token {
                if token.trim() == "" {
                    self.showToast("You are successfully logged out")
                    if UserManager.isRemember {
                        UserManager.isLogin = false
                        Global.showRootView(withIdentifier: StoryboardConstant.LoginVC)
                    }else {
                        Global.flushUserDefaults()
                      //  self.navigationController?.popToRootViewController(animated: true)
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.LoginVC) as! LoginVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    return
                }
            } else {
                self.showToast("You are successfully logged out")
                if UserManager.isRemember {
                    UserManager.isLogin = false
                    Global.showRootView(withIdentifier: StoryboardConstant.LoginVC)
                }else {
                    Global.flushUserDefaults()
                   // self.navigationController?.popToRootViewController(animated: true)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.LoginVC) as! LoginVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                return
            }
            let parameterDic = ["deviceId":UserManager.token ?? " "]
            self.hudView.isHidden = false
            APIClient.logout(paramters: parameterDic) { (result) in
                switch result {
                case .success(let user):
                    if let result = user.result {
                        if result == "1" {
                            self.showToast("You are successfully logged out")
                            if UserManager.isRemember {
                                UserManager.isLogin = false
                                Global.showRootView(withIdentifier: StoryboardConstant.LoginVC)
                            }else {
                                Global.flushUserDefaults()
                               // self.navigationController?.popToRootViewController(animated: true)
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.LoginVC) as! LoginVC
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        } else if let message = user.message {
                            self.hudView.isHidden = true
                            DispatchQueue.main.async {
                                self.showToast(message)
                            }
                        }
                    }
                    
                case .failure(let error):
                    self.hudView.isHidden = true
                    if error.localizedDescription == noDataMessage || error.localizedDescription == noDataMessage1 {
                        self.showAlert(title: kAppName, message: AppMessages.msgFailed)
                    } else {
                        self.showAlert(title: kAppName, message: error.localizedDescription)
                    }
                }
            }

        default:
            print("default")
        }
    }
    
    //Method for show sales UI
    /**
 Method called when top sale button was clicked. Instantiate TopSaleVC and push vc
     */
    private func showSalesVC() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.SalesSellAllVC) as! SalesSellAllVC
      //  if let salesData = salesData {
        //    vc.salesData = salesData
       // }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //Method for show order UI
    /**
 Method called when oreder list button was clicked. Instantiate OrderListVC and push vc
     */
    private func showOrderVC() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.OrderListVC) as! OrderListVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //Get dashboard data from server
    /**
 Method called in viewWillAppear. Display hud view. If UserManager class does not has restaurant id, then return. Take parameter restaurant id and pass in dashboard method of APIClient class. Hide hud view. If api hit is successful, then put data thus obtained in dasboardData where all data is stored. Call manageData method which displays all total summary labels of dashboard. If api hit is not successful, if error message is noDataMessage or noDataMessage1 in Constants.swift, display message msgFailed in AppMessages.swift in dialog else display error message in dialog.
     */
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
                ///display all total summary labels of dashboard
                self.manageData()
                
                self.initWeeklyChart()
                
                self.reloadTable()
                
            case .failure(let error):
                if error.localizedDescription == noDataMessage || error.localizedDescription == noDataMessage1 {
                    self.showAlert(title: kAppName, message: AppMessages.msgFailed)
                } else {
                    self.showAlert(title: kAppName, message: error.localizedDescription)
                }
            }
        }
    }
    
    //Initialize starting data
    /**
 Method called if dashboard api hit is successful, to display dashboard labels data. If dashboardData is assigned to dashboard, put the values in titleArray (containing title, subtitle and icon) of Dashboard struct. Set data in dashboard struct with title Total Sale, subtitle as value of labelValues totalSale and icon. Similarly, set title, subtitle (value) and icon for Weekly Sale, Total Orders, Weekly Orders, Total Customers, Weekly Customers
     */
    func manageData() {
        if let dashboard = dashboardData {
            Dashboard.titleArray = [Dashboard.Data(title: "Current year's sale", subtitle: dashboard.labelValues.totalSale, icon: #imageLiteral(resourceName: "icon1")),
                                    Dashboard.Data(title: "Current week's sale", subtitle: dashboard.labelValues.weeksale, icon: #imageLiteral(resourceName: "icon2")),
                                    Dashboard.Data(title: "Current year's orders", subtitle: dashboard.labelValues.totalOrders, icon: #imageLiteral(resourceName: "icon3")),
                                    Dashboard.Data(title: "Current week's orders", subtitle: dashboard.labelValues.weeklyOrder, icon: #imageLiteral(resourceName: "icon4")),
                                    Dashboard.Data(title: "Total customers", subtitle: dashboard.labelValues.totalCustomers, icon: #imageLiteral(resourceName: "icon5")),
                                    Dashboard.Data(title: "Current week's customers", subtitle: dashboard.labelValues.weekCustomer, icon: #imageLiteral(resourceName: "icon6"))]
        }
    }
    
    //Reload the table when new data arrive
    /**
 Reload the table. Called inside callDashboardAPI method
     */
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension DashboardVC:UITableViewDataSource {
    /**
     This method asks the data source to return the number of sections in the table view. Set no. of sections to 1. Set no data label to width and height of table view. Check if dashboardData is not nil, if nil then show No data found label and hide footer view else show dashboard data (display footer view and noDataLbl to empty).
     Set no dataLbl text color to theme color, its text alignment to centre and set background view of table view to noDataLbl and return no. of sections.
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSection = 1
        
        let noDataLbl = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
        if let _ = dashboardData {
            tableView.tableFooterView?.isHidden = false
            noDataLbl.text = ""
        } else {
            tableView.tableFooterView?.isHidden = true
            noDataLbl.text = "No data found"
        }
        noDataLbl.textColor = UIColor.themeColor
        noDataLbl.textAlignment = .center
        tableView.backgroundView = noDataLbl
        
        return numberOfSection
    }
    
    /**
     This method returns no. of rows in section. Check if dashboardData is not nil then return count of items in titleArray, i.e., Data struct (contiaing title, subtitle and icon). Return count 0 by default.
     **/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = dashboardData {
            return Dashboard.titleArray.count
        }
        return 0
    }
    
    /**
     This method asks the data source for a cell to insert in a particular location of the table view.
     Set cell value to DashboardCell with color, title, value, icon else return empty DashboardCell (this happens very rarely).
     From title array of dashoboard containing title, subtitle and icon, set value of data's title to lblTitle text field, data's subtitle to lblValue text field, data's icon to imgIcon text field and return cell
     */
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
    
    /**
     This method asks the delegate for the height to use for a row in a specified location. The method returns value 145 for iPad, 115 otherwise.
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if Global.isIpad {
            return 145
        }
        return 115
    }
    
    /**
 Tells the delegate that the specified row is now selected. If index of row is 0, 1, 2 or 3 instantate SalesReportVC and push vc. If index of row is 4 or 5, instantiate SalesSellAllVC and push vc. In default case, print default in logs.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        
        case 0,1,2,3:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.SalesReportVC) as! SalesReportVC
            self.navigationController?.pushViewController(vc, animated: true)
  
        case 4,5:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.SalesSellAllVC) as! SalesSellAllVC
            vc.isCustomer=true
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            print("Default")
        }
    }
}

extension DashboardVC:UITableViewDelegate {

}
