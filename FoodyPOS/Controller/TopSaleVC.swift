//
//  TopSaleVC.swift
//  FoodyPOS
//
//  Created by rajat on 29/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

class TopSaleVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTotalOrders: UILabel!
    @IBOutlet weak var lblTotalAmounts: UILabel!
    @IBOutlet weak var viewTop: UIView!
    
    var salesData:Sale?
    var hudView = UIView()
    
    struct CellIdentifier {
        static let topSaleCell = "topSaleCell"
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
        
        if Global.isIpad {
            // manage height of "See All" button
            tableView.tableFooterView?.frame.size.height = 100
        }
        initHudView()
        callSalesAPI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
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
    
    //MARK: ---------Button actions---------

    @IBAction func btnBackDidClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSeeAllDidClicked(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.SalesSellAllVC) as! SalesSellAllVC
        if let salesData = salesData {
            vc.salesData = salesData
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //Reload the table
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //Call Sales Api
    private func callSalesAPI() {
        guard let restaurentId = UserManager.restaurantID else {
            return
        }
        let lastSun = Date.today().previous(.sunday)
    
        let prameterDic = ["RestaurantId":restaurentId,
                           "startdate":lastSun.getDateString(),
                           "enddate":Date.todayDate]
        self.hudView.isHidden = false
        APIClient.sales(paramters: prameterDic) { (result) in
            self.hudView.isHidden = true
            switch result {
            case .success(let sales):
                self.salesData = sales
                self.setSaleData()
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
    
    //Return all orders and sales count
    func getSaleCount() -> (String, String) {
        var totalOrders = 0
        var totalAmount = 0.0.rounded(toPlaces: 2)
        if let sales = salesData {
            for sale in sales.topRestaurentSale {
                if let order = Int(sale.totalOrder!) {
                    totalOrders = totalOrders + order
                }
                if let amount = Double(sale.totalAmount!) {
                    totalAmount = totalAmount + amount.rounded(toPlaces: 2)
                }
            }
        }
        return ("\(totalOrders)","\(totalAmount.rounded(toPlaces: 2))")
    }
    
    //Set the sales and orders
    func setSaleData() {
        let sale = getSaleCount()
        lblTotalOrders.text = sale.0
        lblTotalAmounts.text = "$" + sale.1
    }
}

extension TopSaleVC:UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSection = 1
        
        let noDataLbl = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
        if let salesData = salesData {
            if salesData.topRestaurentSale.count == 0 {
                tableView.tableFooterView?.isHidden = true
                noDataLbl.text = "No sales found"
            }else {
                tableView.tableFooterView?.isHidden = false
                noDataLbl.text = ""
            }
        } else {
            tableView.tableFooterView?.isHidden = true
            noDataLbl.text = "No sales found"
        }
        noDataLbl.textColor = UIColor.themeColor
        noDataLbl.textAlignment = .center
        tableView.backgroundView = noDataLbl
        
        return numberOfSection
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let salesData = salesData {
            return salesData.topRestaurentSale.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.topSaleCell) as? TopSaleCell else {
                return TopSaleCell()
            }
        if Global.isIpad {
            cell.lblLetter.layer.cornerRadius = 45.0
        }
        if let salesData = salesData {
            let topRestaurentData = salesData.topRestaurentSale[indexPath.row]
            cell.lblName.text = topRestaurentData.customerName
            cell.lblOrder.text = "Orders:" + topRestaurentData.totalOrder!
            if let amt = Double(topRestaurentData.totalAmount!) {
                cell.lblPrice.text = "$" + "\(amt.rounded(toPlaces: 2))"
            }
            cell.btnPhone.setTitle(topRestaurentData.contactNumber, for: .normal)
            cell.lblLetter.text = String((topRestaurentData.customerName?.first)!)
        }
            return cell
    }
}

extension TopSaleVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if Global.isIpad {
            return 220.0
        }
        return 150.0
    }
}
