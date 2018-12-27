//
//  OrderListVC.swift
//  FoodyPOS
//
//  Created by rajat on 31/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

struct Status {
    var isOpened = Bool()
}

class OrderListVC: UIViewController {
    @IBOutlet weak var lblTotalOrders: UILabel!
    @IBOutlet weak var lblTotalAmounts: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var btnStartDate: UIButton!
    @IBOutlet weak var btnEndDate: UIButton!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var viewTop: UIView!

    var statusData = [Status]()
    var orderData:Order?
    var hudView = UIView()
    
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
        tableView.delegate = self
        tableView.dataSource = self

        initHudView()

        // "Done" button settings on keyboard
        let keyboardDoneButtonView = UIToolbar.init()
        keyboardDoneButtonView.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneClicked(sender:)))
        
        keyboardDoneButtonView.items = [doneButton]
        txtSearch.inputAccessoryView = keyboardDoneButtonView

        let lastSun = Date.today().previous(.sunday)
        btnStartDate.setTitle(lastSun.getDateString(), for: .normal)
        btnEndDate.setTitle(Date.todayDate, for: .normal)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewSearch.isHidden = true
        txtSearch.delegate = self
        
        if orderData == nil {
            callOrderAPI()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        txtSearch.text = ""
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
    @IBAction func btnDateStartDidClicked(_ sender: UIButton) {
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
    
    @IBAction func btnDateEndDidClicked(_ sender: UIButton) {
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
   
    @IBAction func btnDateSearchDidClicked(_ sender: UIButton) {
        if Date.getDate(fromString: (btnStartDate.titleLabel?.text)!)! <= Date.getDate(fromString: (btnEndDate.titleLabel?.text)!)! {
            callOrderAPI()
        }else {
            self.showToast("Start date must be less than or equal to end date")
        }
    }
    
    @IBAction func btnSearchBarDidClicked(_ sender: UIButton) {
        if viewSearch.isHidden {
            txtSearch.text = ""
            sender.isSelected = true
            viewSearch.isHidden = false
            txtSearch.becomeFirstResponder()
        }
    }
    
    @IBAction func btnBackDidClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSearchDidClicked(_ sender: UIButton) {
        viewSearch.isHidden = true
        txtSearch.resignFirstResponder()
    }
    
    /**
        Fetch Orders from API
     */
    func callOrderAPI() {
        guard let restaurentId = UserManager.restaurantID else {
            return
        }
        let prameterDic = ["RestaurantId":restaurentId,
                            "startdate":(btnStartDate.titleLabel?.text)!,
                           "enddate":(btnEndDate.titleLabel?.text)!,
                           "ordernumber":"null".replacingOccurrences(of: "\"", with: "")] as [String : Any]
        
        self.hudView.isHidden = false
        APIClient.order(paramters: prameterDic) { (result) in
            self.hudView.isHidden = true
            switch result {
            case .success(let order):
                self.orderData = order
                self.initData()
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
    
    //Reload the table
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //Initialize the data when UI Load
    func initData() {
        if let order = orderData {
            lblTotalOrders.text = order.totalOrders
            lblTotalAmounts.text = "$" + order.totalAmount!
            if let date = order.date {
                for _ in 0...date.count {
                    var status = Status()
                    status.isOpened = false
                    statusData.append(status)
                }
            }
        }
    }
    
    @objc func doneClicked(sender: AnyObject) {
        self.view.endEditing(true)
        txtSearch.resignFirstResponder()
        if txtSearch.text == "" {
            self.showToast("Please enter an order number")
        }else {
            guard let restaurentId = UserManager.restaurantID else {
                return
            }
            let prameterDic = ["RestaurantId":restaurentId,
                               "startdate":"",
                               "enddate":"",
                               "ordernumber":txtSearch.text!] as [String : Any]
           
            self.hudView.isHidden = false
            APIClient.orderSearch(paramters: prameterDic) { (result) in
                self.hudView.isHidden = true
                switch result {
                case .success(let order):
                    if let resultCode = order.byOrderNumber.first?.resultCode {
                        if resultCode == "0" {
                            if let message = order.byOrderNumber.first?.message {
                                self.showToast(message)
                            }
                        }
                    } else {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.OrderDetailVC) as! OrderDetailVC
                        vc.onClick = order.byOrderNumber.first?.onClick
                        vc.totalPrice =  order.byOrderNumber.first?.totalPrices
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                case .failure(let error):
                    if error.localizedDescription == noDataMessage || error.localizedDescription == noDataMessage1 {
                        self.showAlert(title: kAppName, message: AppMessages.msgFailed)
                    }else {
                        self.showAlert(title: kAppName, message: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    //Get the total amount of order detail
    private func getTotalAmountOfOrders(orders:[OrderNumberDetail]) -> String {
        var totalPrice = 0.0.rounded(toPlaces: 2)
        for order in orders {
            if let price = Double(order.totalPrices!) {
                totalPrice = totalPrice + price.rounded(toPlaces: 2)
            }
        }
        return "\(totalPrice.rounded(toPlaces: 2))"
    }
}

//MARK: ---------Table view datasorce---------

extension OrderListVC:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
         let noDataLbl = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
        if let order = orderData {
            if let date = order.date {
                if date.count == 0 {
                    noDataLbl.text = "No orders found"
                }else {
                    noDataLbl.text = ""
                }
                noDataLbl.textColor = UIColor.themeColor
                noDataLbl.textAlignment = .center
                tableView.backgroundView = noDataLbl
                return date.count
            }
        }else {
            noDataLbl.text = "No orders found"
            noDataLbl.textColor = UIColor.themeColor
            noDataLbl.textAlignment = .center
            tableView.backgroundView = noDataLbl
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if statusData[section].isOpened {
            if let order = orderData {
                if let date = order.date {
                    if let orderNumber = date[section].orderNumberDetails {
                        return orderNumber.count + 1
                    }
                }
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as? OrderListCell else {
                return OrderListCell()
            }
            if let order = orderData {
                if let date = order.date {
                    if statusData[indexPath.section].isOpened {
                        cell.imgHeader.transform = CGAffineTransform(rotationAngle: .pi)
                    }else {
                        cell.imgHeader.transform = CGAffineTransform.identity
                    }
                    cell.lblHeaderDate.text = date[indexPath.section].orderDate
                    if let orderNumberDetail = date[indexPath.section].orderNumberDetails {
                        cell.lblHeaderOrder.text = "\(orderNumberDetail.count) order(s)"
                        cell.lblHeaderPrice.text = "$" + getTotalAmountOfOrders(orders: orderNumberDetail)
                    }
                }
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as? OrderListCell else {
                return OrderListCell()
            }
            if let order = orderData {
                if let date = order.date {
                    if let orderNumber = date[indexPath.section].orderNumberDetails {
                        if let num = orderNumber[indexPath.row-1].orderNo {
                            cell.lblListNum.text = "#" + num
                        }
                        cell.btnListTIme.setTitle(orderNumber[indexPath.row-1].pickupTime, for: .normal)
                        if let price = orderNumber[indexPath.row-1].totalPrices {
                            if let dPrice = Double(price) {
                                cell.lblListPrice.text = "$" + "\(dPrice.rounded(toPlaces: 2))"
                            }
                        }
                    }
                }
            }
            return cell
        }
    }
}

//MARK: ---------Table view delegate---------
extension OrderListVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let cell = tableView.cellForRow(at: indexPath) as! OrderListCell
        
        if indexPath.row == 0 {
            if statusData[indexPath.section].isOpened {
                statusData[indexPath.section].isOpened = false
            }else {
                statusData[indexPath.section].isOpened = true
            }
            let sections = IndexSet(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
        }else {
            if let order = orderData {
                if let date = order.date {
                    if let orderNumber = date[indexPath.section].orderNumberDetails {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.OrderDetailVC) as! OrderDetailVC
                       // vc.onClick = orderNumber[indexPath.row - 1].onClick
                        vc.orderNo = orderNumber[indexPath.row - 1].orderNo!
                       vc.totalPrice =  orderNumber[indexPath.row - 1].totalPrices
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if Global.isIpad {
            return 80.0
        }
        return 44.0
    }
}

extension OrderListVC:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.text == "" {
            self.showToast("Please enter an order number")
        }else {
            guard let restaurentId = UserManager.restaurantID else {
                return false
            }
            let prameterDic = ["RestaurantId":restaurentId,
                               "startdate":(btnStartDate.titleLabel?.text)!,
                               "enddate":(btnEndDate.titleLabel?.text)!,
                               "ordernumber":textField.text!] as [String : Any]
            
            APIClient.orderSearch(paramters: prameterDic) { (result) in
                switch result {
                case .success(let order):
                    print(order)
                    
                case .failure(let error):
                    if error.localizedDescription == noDataMessage || error.localizedDescription == noDataMessage1 {
                        self.showAlert(title: kAppName, message: AppMessages.msgFailed)
                    }else {
                        self.showAlert(title: kAppName, message: error.localizedDescription)
                    }
                }
            }
        }
        return true
    }
}
