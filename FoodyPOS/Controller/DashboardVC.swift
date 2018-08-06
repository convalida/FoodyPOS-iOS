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

    @IBOutlet weak var btnWeek: UIButton!
    @IBOutlet weak var btnMonth: UIButton!
    @IBOutlet weak var btnYear: UIButton!
    @IBOutlet weak var btnSale: UIButton!
    @IBOutlet weak var btnOrders: UIButton!
    @IBOutlet weak var chartView: HIChartView!
    
    var xAxisData = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    var spline1Data = [3, 4, 3, 5, 4, 10, 12]
    var spline2Data = [1, 3, 4, 3, 3, 5, 4]
    
    struct Area {
        static var isAreaOne = true
        static var isAreaTwo = true
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
        
        initChart()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initChart() {
        let options = HIOptions()
        let chart = HIChart()
        chart.type = "areaspline"
        
        let title = HITitle()
        title.text = ""
        
        let xaxis = HIXAxis()
        xaxis.categories = xAxisData
        
        let yaxis = HIYAxis()
        yaxis.title = HITitle()
        yaxis.title.text = ""
        
        let tooltip = HITooltip()
        tooltip.shared = 1
        tooltip.valueSuffix = " units"
        
        let credits = HICredits()
        credits.enabled = 0
        
        let exporting = HIExporting()
        exporting.enabled = false
        
        let plotoptions = HIPlotOptions()
        plotoptions.areaspline = HIAreaspline()
        plotoptions.areaspline.fillOpacity = 0.5
        plotoptions.areaspline.dataLabels = HIDataLabels()
        plotoptions.areaspline.dataLabels.enabled = true
        
        let areaspline1 = HIAreaspline()
        areaspline1.name = "John"
        areaspline1.data = spline1Data
        
        let areaspline2 = HIAreaspline()
        areaspline2.name = "Jane"
        areaspline2.data = spline2Data
        
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
        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.OrderListVC) as! OrderListVC
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func btnBestSellerDidClicked(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.BestSellerVC) as! BestSellerVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSaleDidClicked(_ sender: UIButton) {
        Area.isAreaOne = !Area.isAreaOne
        initChart()
    }
    
    @IBAction func btnOrdersDidClicked(_ sender: UIButton) {
        Area.isAreaTwo = !Area.isAreaTwo
        initChart()
    }
    
    @IBAction func btnWeekDidClicked(_ sender: UIButton) {
    }
    
    @IBAction func btnMonthDidClicked(_ sender: UIButton) {
    }
    
    @IBAction func btnYearDidClicked(_ sender: UIButton) {
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
        return Dashboard.titleArray.count
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
        return 115
    }
}

extension DashboardVC:UITableViewDelegate {
    
}
