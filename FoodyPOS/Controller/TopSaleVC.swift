//
//  TopSaleVC.swift
//  FoodyPOS
//
//  Created by rajat on 29/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

class TopSaleVC: UIViewController {

    ///Outlet for table view
    @IBOutlet weak var tableView: UITableView!
    ///Outlet for toal orders text
    @IBOutlet weak var lblTotalOrders: UILabel!
    ///Outlet for total amount text
    @IBOutlet weak var lblTotalAmounts: UILabel!
    ///Outlet for top view or navigation bar
    @IBOutlet weak var viewTop: UIView!
    
    ///Strucute for Sales instantiated
    var salesData:Sale?
    ///Instantiate hud view
    var hudView = UIView()
    
    
    /**
 Structure for cell identifier for topSale cell
     */
    struct CellIdentifier {
        ///Initialize topSale cell identifier
        static let topSaleCell = "topSaleCell"
    }
    
    ///Set status bar to visible
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    ///Set light content of status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: ---------View Life Cycle---------
    /**
 Life cycle method called after view is loaded. Set data source and delegate of table view to self. If device is iPad, then ser height of table footer view to 100, for height See All button. Call initHudView and callSalesAPI method
     */
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

    ///Called before the view is loaded.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    ///Sent to the view controller when the app receives a memory warning.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    //MARK: ---------Button actions---------

    /**
     When back button is clicked, pop the top view controller from navigation stack and update the display.
     */
    @IBAction func btnBackDidClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /**
     See All button clicked. Instantiate SalesSellAllVC. Put sales data in vc and push the vc
     */
    @IBAction func btnSeeAllDidClicked(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.SalesSellAllVC) as! SalesSellAllVC
        if let salesData = salesData {
            vc.salesData = salesData
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    ///Reload the table
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //Call Sales Api
    /**
     This method is called in viewDidLoad. If UserManager class does not have Restaurant id, return. Find previous occurance of Monday. Display hud view. Pass restaurant id from UserManager class, previous occurance of Monday as start date and today's date as end date parameter in sales method in APIClient class. Display hud view. If result of api hit is successful, put response of sales in salesData, call setSaleData method and reload table method. If api hit is not successful, if error message is noDataMessage or noDataMessage1 in Constants.swift, display message msgFailed in AppMessages.swift in dialog else display error message in dialog.
     */
    private func callSalesAPI() {
        guard let restaurentId = UserManager.restaurantID else {
            return
        }
        let lastSun = Date.today().previous(.monday)
    
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
    /**
     Called inside setSaleData method. Initalize total orders and total amount. If salesData has value, for all sale, sum the no. of orders if it has orders and sum the amount and round off to 2 places if it has amount and return total orders and amount
     */
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
    /**
     Get total orders and total amount and set it to specified text fields.
     */
    func setSaleData() {
        let sale = getSaleCount()
        lblTotalOrders.text = sale.0
        lblTotalAmounts.text = "$" + sale.1
    }
}

extension TopSaleVC:UITableViewDataSource {
    
    /**
     Return no. of sections in table view. Initailize no. of sections. Set noDataLbl to height and width of table view. If saleData has value, if topRestaurantSale count is 0, hide footer view of table and set noDataLbl text to No sale found, else display footer view and noDataLbl text to null. If saleData does not have vlaue, hide footer view ns set text to No sale found. Set noDataLbl text color to theme color, it alignemnt to centre and set noDataLbl view as background of table view. Return no. of sections- 1
     */
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

    /**
     Method returns no. of rows in section. If saleData has value, then return count of topRestaurantSale else return 0
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let salesData = salesData {
            return salesData.topRestaurentSale.count
        }
        return 0
    }
    
    /**
     This method asks the data source for a cell to insert in a particular location of the table view. Set cell to TopSaleCell if cell identifier is topSaleCell, else set cell to an empty TopSaleCell (this happens very rarely).
     If device is iPad, set corner radius of letter text field to 45. Set saleData to saleData. Get row of topRestaurantSale, set customer name, and order to specified text field, amount rounded to amount text field, phone no. to corresponding text field and first element of customer name to letter text field and return cell.
     */
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
    
    /**
     Tells the delegate that the specified row is now selected. Get row of topRestaurantSale, set customerid, is customer id of row, instantiate CustomerDetailVC, pass customer id to vc and push vc
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let salesData = salesData {
            let topRestaurentData = salesData.topRestaurentSale[indexPath.row]
            if let customerId = topRestaurentData.customerId {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.CustomerDetailVC) as! CustomerDetailVC
                vc.customerId = customerId
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension TopSaleVC:UITableViewDelegate {
    /**
     Asks the delegate for the height to use for a row in a specified location.
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    /**
     Asks the delegate for the estimated height of a row in a specified location. If device is iPad, estimated height is 220, by defualt estimated height is 150
     */
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if Global.isIpad {
            return 220.0
        }
        return 150.0
    }
}
