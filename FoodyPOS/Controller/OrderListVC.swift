//
//  OrderListVC.swift
//  FoodyPOS
//
//  Created by rajat on 31/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

///Rajat ji, please update this 
struct Status {
    ///Boolean for Rajat ji please update this
    var isOpened = Bool()
}

///View controller class for Orderlist section
class OrderListVC: UIViewController {
    ///Outlet for total orders text
    @IBOutlet weak var lblTotalOrders: UILabel!
    ///Outlet for amount text
    @IBOutlet weak var lblTotalAmounts: UILabel!
    ///Outlet for table view
    @IBOutlet weak var tableView: UITableView!
    ///Outlet for search view for order no. search
    @IBOutlet weak var viewSearch: UIView!
    ///Outlet for start date
    @IBOutlet weak var btnStartDate: UIButton!
    ///Outlet for end date
    @IBOutlet weak var btnEndDate: UIButton!
    ///Rajat ji please update this
    @IBOutlet weak var txtSearch: UITextField!
    ///Rajat ji please update this id this is search button followed by start date and end date order no. search button (microscope)
    @IBOutlet weak var btnSearch: UIButton!
    ///Outlet for top view or navigation bar. Rajat ji please check this
    @IBOutlet weak var viewTop: UIView!

    //Rajat ji please update this
    var statusData = [Status]()
    ///Structure of Order instantiated
    var orderData:Order?
    ///Hud view instantiated
    var hudView = UIView()
    
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
     Life cycle method called after view is loaded. Set delegate and data source of table view to self. Initalize hud view.
     Initialize done button on keyboard, set its size. Set done button and blank space between items and attach it as an accessory view to the system-supplied keyboard to search text
    Set start date to previous occurance of Monday considering today's date and end sate to today's date.
    */
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
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        keyboardDoneButtonView.items = [flexibleSpace, doneButton]
        txtSearch.inputAccessoryView = keyboardDoneButtonView

        let lastSun = Date.today().previous(.monday)
      /** if(Date.today() != (.monday)){
         
            let lastSun=Date.today().previous(.monday)-7
        }**/
        btnStartDate.setTitle(lastSun.getDateString(), for: .normal)
        btnEndDate.setTitle(Date.todayDate, for: .normal)
    }

    /**
    Called before the view is loaded. Hide search view. Set delegate of search text to self. 
    If orderData is null, i.e., it is called for first time, Rajat ji please check this.
    call method callOrderAPI method which hits the orders web service.
    */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewSearch.isHidden = true
        txtSearch.delegate = self
        
        if orderData == nil {
            callOrderAPI()
        }
    }
    
    /**
    Called when the view is about to disappear. Set search text to null
    */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        txtSearch.text = ""
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
    
    //MARK: ---------Button actions---------
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
   Method called when search button corresponding to from and to date is clicked. If date in btnStartDate is less than or equal to date in btnEndDate,
   call method callOrderAPI which hits orders web service, else show message Start date must be less than or equal to end date in toast.
   */
    @IBAction func btnDateSearchDidClicked(_ sender: UIButton) {
        if Date.getDate(fromString: (btnStartDate.titleLabel?.text)!)! <= Date.getDate(fromString: (btnEndDate.titleLabel?.text)!)! {
            callOrderAPI()
        }else {
            self.showToast("Start date must be less than or equal to end date")
        }
    }
    
    /**
    When this method is called Rajat ji please update this, on click of search icon or search bar, as on click of action bar, dashboard was loaded.
    If search view is hidden, set search text to null, 
    set sender (search button on action bar) to be selected. Rajat ji please check this.
    Set search view to be visible. Set search text as first responder, i.e., first object in a responder chain to receive an event or action message.
    */
    @IBAction func btnSearchBarDidClicked(_ sender: UIButton) {
        if viewSearch.isHidden {
            txtSearch.text = ""
            sender.isSelected = true
            viewSearch.isHidden = false
            txtSearch.becomeFirstResponder()
        }
    }
    
    /**
     When back button is clicked, pop the top view controller from navigation stack and update the display.
     */
    @IBAction func btnBackDidClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /**
    When this method is called, Rajat ji please update this.
    Hide search view, hide selection from search text and hide keyboard.
    */
    @IBAction func btnSearchDidClicked(_ sender: UIButton) {
        viewSearch.isHidden = true
        txtSearch.resignFirstResponder()
    }
    
    /**
       This method is used to fetch Orders from API. If UserManager class does not have Restaurant id, return.
       Take paramters restaurant id from UserManager class, start date and end date from btnStartDate and btnEndDate resp., order no. as null.
       Display hud view. Call method order from APIClient class and pass the paramters. Hide hud view. If api hit is successful,
       set response to orderData, Rajat ji please check this.
       Call iniData method which displays total order and total amount. Call reloadTable method which reloads the table.
       If api hit is not successful, if error message is noDataMessage or noDataMessage1 in Constants.swift, display message msgFailed in AppMessages.swift in dialog else display error message in dialog.
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
    
    ///This method reloads the data of table view
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //Initialize the data when UI Load
    /**
    This method is called on successful hit orderlist web service. If orderData is not null, set total orders and total amount to corresponding text fields.
    If date in orderData is not null, after that Rajat ji kindly update the flow.
    */
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
    
    /**
    This method is called when done button on keyboard is clicked after order no. search button was clicked. Rajat ji please check this. 
    End editing is called on which view, Rajat ji please update this.
    Remove selection from search text field and hide keyboard.  If search tyext field is empty, show message Please enter order no. in toast
    else if restaurant id is not in UserManager class, return. Take restaurant id from UserManager class, start date and end date as empty parameters and order no. from search text.
    Display hud view. Pass the parameters to orderSearch method of APIClient class. Hide hud view. If api hit is successful,
    If first result code in byOrderNumber array is not null, Rajat ji please check this. If result code is 0,  
    If first message in byOrderNumber array is not null, show message obtained in response in toast.
    If first result code in byOrderNumber array is null, instantiate OrderDetailVC. Pass first value of onClick in byOrderNumber array to vc. Rajat ji please check this.
    Pass first value of totalPrices in byOrderNumber array to vc and push vc.
    If api hit is not successful, if error message is noDataMessage or noDataMessage1 in Constants.swift, display message msgFailed in AppMessages.swift in dialog else display error message in dialog.
    */
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
    /**
    This method totals amount of orders on a date. Initialize total points to 0 rounded to 2 decimal places. For all orders,
    If order has totalPrices, sum the price, and return sum rounded to 2 decimal places.
    */
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
    /**
    Method returns no. of sections of table view. Set width and height of noDataLbl to width and height of table view.
    If orderData is not null, if order has date, if count of date array is 0, set noDataLbl text to No orders found, else, set noDataLbl text to null.
    Set text color of noDataLbl to theme color, alignment to centre, set background color of table view to noDataLbl.
    Return count of elements in Date array. If orderData does not has data, set noDataLbl text to No orders found.    
    Set noDataLbl text color to theme color, its alignment to center, set background of table view to noDataLbl. Return 0.
    */
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
    
    /**
    This method returns no. of rows in section of table view.
    Rajat ji please mention the flow.
    Return no. of rows 1 by default.
    */
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
    
    /**
    This method asks the data source for a cell to insert in a particular location of the table view. For 0th row, set cell to OrderListCell if cell identifier is headerCell, else set cell to empty OrderListCell (default case which happens rarely)
    If orderData is not null, if order has date array, after that Rajat ji kindly mention the flow.
    In date array, set orderDate to corresponding text field at particular index of section. Rajat ji please check this.
    If in date array, orderNumberDetails is not null, set count of items in orderNumberDetail to lblHeaderOrder text field and value returned from method getTotalAmountOfOrders in lblHeaderPrice text field at particular index of section. Rajat ji please check this.
    Return cell. Rajat please mention the reason for displaying this ui for 0th row only.
    For row other than 0th row, set cell to OrderListCell if cell identifier is headerCell, else set cell to empty OrderListCell (default case which happens rarely)
    If orderData is not null, if order has date, if in date array, if orderNumberDetails at particualr row of particular section is not null, Rajat ji please check and update further.
    Set rder no. at lblListItem text field concatenated with #.
    Set pickup time at what position Rajat ji kindly mention. 
    If price at position - Rajat ji please mention is not null, and converting price to double is not null, set double price rounded to 2 decimal places to lblList price text field and return cell.
    */
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
    /**
    Tells the delegate that the specified row is now selected. For 0th row, Rajat ji please mention the flow. 
    For rows other than 0, if orderData is not null, if order has date array, if position of index of particular section is not null, Rajat ji please check this.
    instantiate OrderDetailVC, pass order no. Rajat ji please mention the position, to vc
    pass start date and end date from btnStartDate and btnEndDate resp., pass price to vc Rajat ji please mention the positioning.
    Push vc 
    */
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
                        vc.startDate = btnStartDate.titleLabel?.text
                        vc.endDate = btnEndDate.titleLabel?.text
                       vc.totalPrice =  orderNumber[indexPath.row - 1].totalPrices
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
    
    /**
      Asks the delegate for the height to use for a row in a specified location. If device is iPad, return height 80, else return 44
    */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if Global.isIpad {
            return 80.0
        }
        return 44.0
    }
}

extension OrderListVC:UITextFieldDelegate {
    /**
    The text field calls this method whenever the user taps the return button. Rajat ji please check this as checked on Brajesh sir's iPhone to check functionality, but there is no return button. Kindly clarify .It is used for order search text field it is used here.
     Dismiss the keyboard. If text field is empty, show toast message Please enter an order no. If text field is not empty,
     if UserManager class does not have restaurant id, return. Take parameter restaurant id from UserManager class, start date and end date from btnStartDate and btnEndDate resp.,
    and order no. from text field. Call orderSearch method from APIClient class and pass the parameters. On successful hit of web service,
    print response in logs. OrderDetailVc is not launched in case of success earlier. Rajat ji please check this and reason of it. 
    If api hit is not successful, if error message is noDataMessage or noDataMessage1 in Constants.swift, display message msgFailed in AppMessages.swift in dialog else display error message in dialog.
    Return true, i.e., the text field should implement its default behavior for the return button.
    */
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
