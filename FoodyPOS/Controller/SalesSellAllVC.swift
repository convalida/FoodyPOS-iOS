//
//  SalesSellAllVC.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 04/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

///View controller class for Sales 
class SalesSellAllVC: UIViewController {
    ///Outlet for table view
    @IBOutlet weak var tableView: UITableView!
    ///Outlet for start date
    @IBOutlet weak var btnStartDate: UIButton!
    ///Outlet for end date
    @IBOutlet weak var btnEndDate: UIButton!
    ///Outlet for title button which is displayed as text.
    @IBOutlet weak var btnTitle: UIButton!
    ///Outlet for total orders
    @IBOutlet weak var lblTotalOrders: UILabel!
    ///Outlet for total amount
    @IBOutlet weak var lblTotalAmounts: UILabel!
    ///Outlet for top view - navigation bar
    @IBOutlet weak var viewTop: UIView!

    ///Structure for Sales instantiated
    var salesData:Sale?
    ///Structure of Customers instantiated
    var customersData:Customers?
    ///Set boolean isCustomer value to false by default
    var isCustomer = false
    ///Instantiate hud view
    var hudView = UIView()
    var isSearch=false
    
    ///Structure for cell identifier for topSaleCell
    struct CellIdentifier {
        ///Initialize topSaleCell identifier
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
    
    /**
     Life cycle method called after view is loaded. Set data source and delegate of table view to self.
     Call initHudView method. Set start date to occurance of Monday of current week. Set end date to today's date.
     If saleData is null, set title on action bar to Customers, call method callCustomersAPI and set isCustomer vlaue to true else call setSaleData method,
    the title in this case (isCustomer=false) is set in StoryBoard.
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        initHudView()
        
       // let lastSun = Date.today().previous(.monday)
     //   btnStartDate.setTitle(lastSun.getDateString(), for: .normal)
     //   btnEndDate.setTitle(Date.todayDate, for: .normal)
        btnStartDate.setTitle("mm/dd/yyyy", for: .normal)
        btnEndDate.setTitle("mm/dd/yyyy", for: .normal)
        if isCustomer == true {
            btnTitle.setTitle("Customers", for: .normal)
            callCustomersAPI()
         //   isCustomer = true
        } else {
            callSalesAPI()
            setSaleData()
        }
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

    /**
    Called when start date is clicked. Instantiate date picker. Set date picker mode to date. Set maximum date to today's date.
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
    End date is clicked. Instantiate date picker. Set date picker mode to date. Set maximum date to today's date.
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
    
    /**
    Button search is clicked. If date in btnStartDate is less than or equal to date in btnEndDate. If isCustomer value is false call method callSalesAPI else call method call customersAPI
    If date in startBtnDate is greater than date in endBtnDate, then display start date must be less than or equal to end date in toast.
    */
    @IBAction func btnSearchDidClicked(_ sender: UIButton) {
        isSearch=true
        if Date.getDate(fromString: (btnStartDate.titleLabel?.text)!)! <= Date.getDate(fromString: (btnEndDate.titleLabel?.text)!)! {
            if !isCustomer {
                callSalesAPI()
            }else {
                callCustomersAPI()
            }
        }else {
            self.showToast("Start date must be less than or equal to end date")
        }
    }

    /**
     When back button is clicked, pop the top view controller from navigation stack and update the display.
     */
    @IBAction func btnBackDidClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }


    /**
    This method is responsible for hitting sales web service. If UserManager class does not have restaurant id, return.
    Take parameters restaurant id from UserManager, start date and end date from start date button and end date button resp.
    Display hud view. Pass parameter to sales method using APIClient class. Hide hud view. If api hit is successful, set reponse to salesData, call setSaleData method and reloadTable method.
    If api hit is not successful, if error message is noDataMessage or noDataMessage1 in Constants.swift, display message msgFailed in AppMessages.swift in dialog else display error message in dialog.
    */
    private func callSalesAPI() {
        guard let restaurentId = UserManager.restaurantID else {
            return
        }
     //   let nullString="null"
  //      let test : [String : AnyObject] = ["null" : NSNull()]
        
        var parameterDic = [String:Any]()
        
      /**  if isSearch {
            parameterDic = ["RestaurantId":restaurentId,
                           "fromdate":(btnStartDate.titleLabel?.text)!,
                           "enddate":(btnEndDate.titleLabel?.text)!]
        }else {**/
        parameterDic = ["RestaurantId":restaurentId,
                    //      "startdate":(btnStartDate.titleLabel?.text)!,
                      //     "enddate":(btnEndDate.titleLabel?.text)!]
            "startdate":"null".replacingOccurrences(of: "\"", with: ""),
             "enddate":"null".replacingOccurrences(of: "\"", with: "")]
           // "startdate":test,
            //"enddate":test]
       // }
        self.hudView.isHidden = false
        APIClient.sales(paramters: parameterDic) { (result) in
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
    
    /**
    This method is responsible for hitting customers web service. If UserManager class does not have restaurant id, return.
    Take parameters restaurant id from UserManager, start date and end date from start date button and end date button resp.
    Display hud view. Pass parameter to customers method using APIClient class. Hide hud view. If api hit is successful, set response to customersData, call setCustomersData method and reloadTable method.
    If api hit is not successful, if error message is noDataMessage or noDataMessage1 in Constants.swift, display message msgFailed in AppMessages.swift in dialog else display error message in dialog.
    */
    func callCustomersAPI() {
        guard let restaurentId = UserManager.restaurantID else {
            return
        }
        let prameterDic = ["RestaurantId":restaurentId,
                           "startdate":(btnStartDate.titleLabel?.text)!,
                           "enddate":(btnEndDate.titleLabel?.text)!]
       
        self.hudView.isHidden = false
        APIClient.customers(paramters: prameterDic) { (result) in
            self.hudView.isHidden = true
            switch result {
            case .success(let customers):
                self.customersData = customers
                self.setCustomerData()
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
    
    ///Reload the table
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //Get total orders or amount of 
    /**
    Called inside setCustomerData method. Initialize total orders and total amount. If customersData has data, for all customers in selected date range,
    If Customer response has totalOrders, sum the no. of orders. If Customer response has totalAmount, then total of amounts and roundoff to 2 decimal places and return totalOrders and totalAmount. 
    */
    func getCustomerCount() -> (String, String) {
        var totalOrders = 0
        var totalAmount = 0.0.rounded(toPlaces: 2)
        if let customers = customersData {
            for customer in customers.byDateSelected {
                if let order = Int(customer.totalOrders) {
                    totalOrders = totalOrders + order
                }
                if let amount = Double(customer.totalamount) {
                    totalAmount = totalAmount + amount.rounded(toPlaces: 2)
                }
            }
        }
        return ("\(totalOrders)","\(totalAmount.rounded(toPlaces: 2))")
    }
    
    //Get total order or amount of sales
    /**
    Called inside setSaleData method. Initialize total orders and total amount. If setSaleData has data, for all sales in allSales range (response),
    If Sale response has totalOrders, sum the no. of orders. If Sale response has totalAmount, then total of amounts and roundoff to 2 decimal places and return totalOrders and totalAmount. 
    */
    func getSaleCount() -> (String, String) {
        var totalOrders = 0
        var totalAmount = 0.0.rounded(toPlaces: 2)
        if let sales = salesData {
            for sale in sales.allSales {
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
    
    //Set the order and amount
    /**
    Method displays total orders and total amount for Sales. Call getSaleCount method to calculate total no. of orders and total amount. Set total no. of orders and total amount to corresponding text fields 
    */
    func setSaleData() {
        let sale = getSaleCount()
        lblTotalOrders.text = sale.0
        lblTotalAmounts.text = "$" + sale.1
    }
    
    //Set the order and amount
    /**
    Method displays total orders and total amount for Customers. Call getCustomerCount method to calculate total no. of orders and total amount. Set total no. of orders and total amount to corresponding text fields 
    */
    func setCustomerData() {
        let customer = getCustomerCount()
        lblTotalOrders.text = customer.0
        lblTotalAmounts.text = "$" + customer.1
    }
}

extension SalesSellAllVC:UITableViewDataSource {
   
   /**
   Method returns no. of sections of table view. Initialize no. of sections to 1. Set noDataLbl width and height to width and height of table view.
   If saleData has data, if count of allSales is 0, set noDataLbl text to No sales found else noDataLbl to null.
    If customerData has data, if count of byDateSelected is 0, set noDataLbl text to No customers found else noDataLbl to null.
    Else set noDataLbl text to No customers found. Set noDataLbl text color to theme color, text alignment to centre and set background of table view to noDataLbl.
    Return no. of sections.
   */
    func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSection = 1
        
        let noDataLbl = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
        if let salesData = salesData {
            if salesData.allSales.count == 0 {
                noDataLbl.text = "No sales found"
            }else {
                noDataLbl.text = ""
            }
        } else if let customers = customersData {
            if customers.byDateSelected.count == 0 {
                noDataLbl.text = "No customers found"
            }else {
                noDataLbl.text = ""
            }
        }else {
            noDataLbl.text = "No customers found"
        }
        noDataLbl.textColor = UIColor.themeColor
        noDataLbl.textAlignment = .center
        tableView.backgroundView = noDataLbl
        
        return numberOfSection
    }
    
    /**
    This method returns no. of rows in section of table view. If saleData has data, return count of allSales.
    If customerData has data, return count of byDateSelected. Return 0 by default.    
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if let salesData = salesData {
                return salesData.allSales.count
            }else if let customers = customersData {
                return customers.byDateSelected.count
            }
        
        return 0
    }
    
    /**
    This method asks the data source for a cell to insert in a particular location of the table view. Set cell to TopSaleCell if cell identifier is topSaleCell, else set cell to empty TopSaleCell (default case which happens rarely). TopSaleCell is reused here.
     If device is iPad, set corner radius of letter text field to 45. If saleData has data, set row at particular index.
     Set name text to name for a particular row. Set order to total order. Set amount to price text rounded to 2 decimal places.
     Set contactNo. to corresponding text field of row. Set letter text to first character of customer name.
     If cuastomerData has data, set row at particular index. Set name text to name for a particular row. Set order to total order. Set amount to price text rounded to 2 decimal places.
     Set contactNo. to corresponding text field of row. Set letter text to first character of customer name
    Return cell.
    */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.topSaleCell) as? TopSaleCell else {
            return TopSaleCell()
        }
        if Global.isIpad {
            cell.lblLetter.layer.cornerRadius = 45.0
        }
        if let salesData = salesData {
            let topRestaurentData = salesData.allSales[indexPath.row]
            cell.lblName.text = topRestaurentData.customerName
            cell.lblOrder.text = "Orders:" + topRestaurentData.totalOrder!
            if let amt = Double(topRestaurentData.totalAmount!) {
                cell.lblPrice.text = "$" + "\(amt.rounded(toPlaces: 2))"
            }
            cell.btnPhone.setTitle(topRestaurentData.contactNumber, for: .normal)
            cell.lblLetter.text = String((topRestaurentData.customerName?.first)!)
            if(topRestaurentData.status=="Old"){
                cell.lblNew.isHidden=true
            }
            else{
                cell.lblNew.isHidden=false
            }
        } else if let customers = customersData {
            let customer = customers.byDateSelected[indexPath.row]
            cell.lblName.text = customer.customerName
            cell.lblOrder.text = "Orders:" + customer.totalOrders
            if let amt = Double(customer.totalamount) {
                cell.lblPrice.text = "$" + "\(amt.rounded(toPlaces: 2))"
            }
            cell.btnPhone.setTitle(customer.contactNo, for: .normal)
            cell.lblLetter.text = String((customer.customerName.first)!)
        }
        return cell
    }
}

extension SalesSellAllVC:UITableViewDelegate {
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
    
    /**
     Tells the delegate that the specified row is now selected. If isCustomer is true, If customerData contains a value, get row of customer in selected date range,
     instantiate CustomerDetailVC, take customerId from customer and pass it in vc and push vc.
    If isCustomer is false, if saleData contains a value, get row of salesData in allSales,
     instantiate CustomerDetailVC, take customerId from customer and pass it in vc and push vc.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isCustomer {
            if let customers = customersData {
                let customer = customers.byDateSelected[indexPath.row]
                let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.CustomerDetailVC) as! CustomerDetailVC
                vc.customerId = customer.customerId
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            if let salesData = salesData {
                let topRestaurentData = salesData.allSales[indexPath.row]
                if let customerId = topRestaurentData.customerId {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.CustomerDetailVC) as! CustomerDetailVC
                    vc.customerId = customerId
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}
