//
//  SalesSellAllVC.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 04/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

class SalesSellAllVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnStartDate: UIButton!
    @IBOutlet weak var btnEndDate: UIButton!
    @IBOutlet weak var btnTitle: UIButton!
    @IBOutlet weak var lblTotalOrders: UILabel!
    @IBOutlet weak var lblTotalAmounts: UILabel!
    @IBOutlet weak var viewTop: UIView!

    var salesData:Sale?
    var customersData:Customers?
    var isCustomer = false
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        initHudView()
        
        let lastSun = Date.today().previous(.monday)
        btnStartDate.setTitle(lastSun.getDateString(), for: .normal)
        btnEndDate.setTitle(Date.todayDate, for: .normal)
        if salesData == nil {
            btnTitle.setTitle("Customers", for: .normal)
            callCustomersAPI()
            isCustomer = true
        }else {
            setSaleData()
        }
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
    
    @IBAction func btnSearchDidClicked(_ sender: UIButton) {
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
    
    @IBAction func btnBackDidClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func callSalesAPI() {
        guard let restaurentId = UserManager.restaurantID else {
            return
        }
        let prameterDic = ["RestaurantId":restaurentId,
                           "startdate":(btnStartDate.titleLabel?.text)!,
                           "enddate":(btnEndDate.titleLabel?.text)!]
        
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
    
    //Reload the table when new data come
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //Get total orders or amount of customer
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
    func setSaleData() {
        let sale = getSaleCount()
        lblTotalOrders.text = sale.0
        lblTotalAmounts.text = "$" + sale.1
    }
    
    //Set the order and amount
    func setCustomerData() {
        let customer = getCustomerCount()
        lblTotalOrders.text = customer.0
        lblTotalAmounts.text = "$" + customer.1
    }
}

extension SalesSellAllVC:UITableViewDataSource {
   
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if let salesData = salesData {
                return salesData.allSales.count
            }else if let customers = customersData {
                return customers.byDateSelected.count
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
            let topRestaurentData = salesData.allSales[indexPath.row]
            cell.lblName.text = topRestaurentData.customerName
            cell.lblOrder.text = "Orders:" + topRestaurentData.totalOrder!
            if let amt = Double(topRestaurentData.totalAmount!) {
                cell.lblPrice.text = "$" + "\(amt.rounded(toPlaces: 2))"
            }
            cell.btnPhone.setTitle(topRestaurentData.contactNumber, for: .normal)
            cell.lblLetter.text = String((topRestaurentData.customerName?.first)!)
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if Global.isIpad {
            return 220.0
        }
        return 150.0
    }
    
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
