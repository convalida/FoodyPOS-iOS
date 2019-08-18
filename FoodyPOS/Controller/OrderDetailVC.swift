//
//  OrderDetailVC.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 17/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

///View controller class for Order Details screen
class OrderDetailVC: UIViewController {

    ///Outlet for table view
    @IBOutlet weak var tableView: UITableView!
    ///Outlet for name label
    @IBOutlet weak var lblName: UILabel!
    ///Outlet for contact no. label
    @IBOutlet weak var lblContact: UILabel!
    ///Outlet for email label
    @IBOutlet weak var lblEmail: UILabel!
    ///Outlet for total amount label
    @IBOutlet weak var lblTotalAmount: UILabel!
    ///Outlet for navigation bar
    @IBOutlet weak var viewTop: UIView!

    ///Declare variable for onClick structure.
    var onClick:OnClick?
    ///Declare total price string
    var totalPrice:String?
    ///Instantiate hud view
    var hudView = UIView()
    ///Declare order no.
    var orderNo = ""
    ///Declare start date string 
    var startDate:String?
    ///Declare end date string
    var endDate:String?
    
    ///Display status bar
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
     ///Set light content of status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /**
     Life cycle method called after view is loaded. Call method initData which displays customer name, contact no. and email id.
     Set data source and delegate of table view to self. Call initHudView method which initializes the hud view.
    If order no. is not null, call method getOrderDetailByOrderNumber passing order no. in it which hits order detail web service.
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initData()
       
        tableView.dataSource = self
        tableView.delegate = self
        initHudView()
        if orderNo != "" {
            getOrderDetailByOrderNumber(number: orderNo)
        }
    }

    /**
    Called before the view is loaded. If device is iPad, set height of table header view to 200. Here header view is section for user name, contact no., email address.
    Add observer for notification to didReceiveOrderNumber which hits orderdetail web service if order no. is not null. This is used in case of push notification.
    */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Global.isIpad {
            self.tableView.tableHeaderView?.frame.size.height = 200.0
        }
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveOrderNumber(notification:)), name: NSNotification.Name(rawValue: kOrderDetailNotification), object: nil)
    }
    
      ///Sent to the view controller when the app receives a memory warning.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
    This method is called inside viewDidLoad and if order detail web service hit is successful. If onClick struct is not,
    set customer name, contact no. and email to corresponding text fields. If total price is not null, set amount concatenated with $ sign. 
    */
    func initData() {
        if let onClick = onClick {
            lblName.text = onClick.customerName
            lblContact.text = onClick.contactNumber
            lblEmail.text = onClick.email
        }
        
        if let totalPrice = totalPrice {
            lblTotalAmount.text = "$" + totalPrice
        }
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
     When back button is clicked, pop the top view controller from navigation stack and update the display.
     */
    @IBAction func btnBackDidClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /**
    Method called when amount view is clicked. Instantiate AmountVC, if onClick is not null, pass onClick to vc.
    Add view as sub view of view controller and add AmountVC as child view controller
    */
    @IBAction func viewAmountDidClicked(_ sender: UITapGestureRecognizer) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.AmountVC) as! AmountVC
        if let onClick = onClick {
            vc.onClick = onClick
        }
        self.view.addSubview(vc.view)
        self.addChildViewController(vc)        
    }
    
    
    /**
    Method called when amount view is clicked. Instantiate AmountVC, if onClick is not null, pass onClick to vc.
    Add view as sub view of view controller and add AmountVC as child view controller. This method is exactly identical to viewAmounDidClicked because user can click either on view or on button.
    */
    @IBAction func btnAmountDidClicked(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.AmountVC) as! AmountVC
        if let onClick = onClick {
            vc.onClick = onClick
        }
        self.view.addSubview(vc.view)
        self.addChildViewController(vc)
    }
    
    /**
    Method called when customer detail button is clicked. Customer name is set on label outlet or button.
    If onClick is not null, if customer id in onClick is not null, instantiate CustomerDetailVC, pass customer id and push vc.
    */
    @IBAction func btnCustomerDetailDidClicked(_ sender: UIButton) {
         if let onClick = onClick {
            if let customerId = onClick.customerId {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.CustomerDetailVC) as! CustomerDetailVC
                vc.customerId = customerId
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    

    /**
    This method is responsible for hitting web service. If restaurant id in UserManager class is null, then return.
    Take parameter restaurant id from UserManager class, start date and end date if they are not null. Start date and end dates are passed in case view controller is launched by clicking on particular order no. in OrderlistVC.
    Order no. is passed in the method when it is called. Display hud view. Pass parameters to orderSearch method of APIClient class.
    Hide hud view. If api hit is successful, if byOrderNumber structure's first element has result code.
    if result code is 0, if byOrderNumber structure's first element has message, show message in toast.
    If byOrderNumber structure's first element does not have result code, set byOrderNumber structure's first element's on click and total prices.
    Call initData method which sets name, email and contact no. Call reload data method on table view which reloads the rows and sections of table view.
    If api hit is not successful, if error message is noDataMessage or noDataMessage1 in Constants.swift, display message msgFailed in AppMessages.swift in dialog else display error message in dialog.
    */
    private func getOrderDetailByOrderNumber(number:String) {
        guard let restaurentId = UserManager.restaurantID else {
            return
        }

      //  let lastSun = Date.today().previous(.sunday)
        
        let prameterDic = ["RestaurantId":restaurentId,
                           "startdate":(startDate != nil) ? startDate! : "",
                           "enddate":(endDate != nil) ? endDate! : "",
                           "ordernumber":number] as [String : Any]
        
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
                    self.onClick = order.byOrderNumber.first?.onClick
                    self.totalPrice =  order.byOrderNumber.first?.totalPrices
                    self.initData()
                    self.tableView.reloadData()
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
    
    /**
    This method is called inside viewWillAppear. If user information dictionary associated with the notification is not null.
    If orderNo in user information dictionary is String and not null, call method getOrderDetailByOrderNumber and pass order no. which hits order detail web service.
    */
    @objc func didReceiveOrderNumber(notification:Notification) {
        if let info = notification.userInfo as NSDictionary? {
            if let orderNo = info["orderNo"] as? String {
                getOrderDetailByOrderNumber(number: orderNo)
            }
        }
    }
}

//MARK: ---------Table view datasorce---------

extension OrderDetailVC:UITableViewDataSource {
   
   /**
    Method returns no. of sections of table view. Set width and height of noDataLbl to width and height of table view. If onClick is not null,
    If onClick has orderItemDetails, and its count is 0, hide header view of table and set noDataLbl text to No data found. Header view section is the sction containing name, contact no. and email address.
    If onClick has orderItemDetails and its count is not 0, display header view of table view and noDataLbl text to null.
    Set noDataLbl's text color to theme color, alignment to center. Set background view of table view to noDataLbl. 
    Return no. of sections to 1.
    If onClick is null, set noDataLbl text to No data found, text color to theme color, alignment to center. Set background view of table view to noDataLbl.
   Hide header view of table view, return no. of sections to 0.
   */
    func numberOfSections(in tableView: UITableView) -> Int {
        let noDataLbl = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
        if let onClick = onClick {
            if let orderItems = onClick.orderItemDetails {
                if orderItems.count == 0 {
                    tableView.tableHeaderView?.isHidden = true
                    noDataLbl.text = "No data found"
                }else {
                    tableView.tableHeaderView?.isHidden = false
                    noDataLbl.text = ""
                }
                noDataLbl.textColor = UIColor.themeColor
                noDataLbl.textAlignment = .center
                tableView.backgroundView = noDataLbl
                return 1
            }
        }else {
            noDataLbl.text = "No data found"
            noDataLbl.textColor = UIColor.themeColor
            noDataLbl.textAlignment = .center
            tableView.backgroundView = noDataLbl
            tableView.tableHeaderView?.isHidden = true
        }
        return 0
    }
    
    /**
    This method returns no. of rows in section of table view. If onClick is not null, if onClick has orderItemDetails, return count of items in orderItemDetails.
    Return 0 by default.
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let onClick = onClick {
            if let orderItems = onClick.orderItemDetails {
                return orderItems.count
            }
        }
        return 0
    }
    
    /**
    This method asks the data source for a cell to insert in a particular location of the table view. 
    Set cell to OrderDetailCell if cell identifier is detailCell, else return empty OrderDetailCell (default case which happens rarely).
    If onClick is not null, if onClick has orderItemDetails, set items at specified index. Set sub item name, modifier, add on, instruction to corresponding text fields at specified index.
    If price's double value price is not null, set price to corresponding text field, concatenated with $ and rounded to 2 decimal places.
    If total's double value is not null, set total to corresponding text field, concatenated with $ and rounded to 2 decimal places.
    If at particular position, if sub item name is null, hide stackSubItem outlet, else display stackSubItem outlet in OrderDetailCell,
    if modifier is null, hide stackModifier outlet, else display stackModifier outlet in OrderDetailCell, if add on is null, hide stackAddOn outlet, else display stackAddOn outlet in OrderDetailCell,
    if instruction is null, hide stackInstruction outlet, else display stackSubItem outlet in OrderDetailCell, if price is 0, hide stackPrice outlet, else display stackPrice outlet in OrderDetailCell,
    if addOnPrice is 0, hide stackAddOnPrice outlet, else display stackAddOnPrice outlet in OrderDetailCell, if total is 0, hide stackTotal outlet, else display stackTotal outlet in OrderDetailCell.
    Return cell
    */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell") as? OrderDetailCell else {
            return OrderDetailCell()
        }
        if let onClick = onClick {
            if let orderItems = onClick.orderItemDetails {
                let item = orderItems[indexPath.row]
                cell.lblSubitem.text = item.subitemsNames
                cell.lblModifier.text = item.modifier
                cell.lblAddOn.text = item.addOn
                cell.lblInstruction.text = item.instruction
                if let price = Double(item.price!) {
                    cell.lblPrice.text = "$" + "\(price.rounded(toPlaces: 2))"
                }
                if let addOnPrice = Double(item.addOnPrices!) {
                    cell.lblAddOnPrice.text = "$" + "\(addOnPrice.rounded(toPlaces: 2))"
                }
                if let total = Double(item.total!) {
                    cell.lblTotal.text = "$" + "\(total.rounded(toPlaces: 2))"
                }
                if item.subitemsNames == "" {
                    cell.stackSubitem.isHidden = true
                }else {
                    cell.stackSubitem.isHidden = false
                }
                if item.modifier == "" {
                    cell.stackModifier.isHidden = true
                }else {
                   cell.stackModifier.isHidden = false
                }
                if item.addOn == "" {
                    cell.stackAddOn.isHidden = true
                }else {
                    cell.stackAddOn.isHidden = false
                }
                if item.instruction == "" {
                    cell.stackInstruction.isHidden = true
                }else {
                    cell.stackInstruction.isHidden = false
                }
                if item.price == "0" {
                    cell.stackPrice.isHidden = true
                }else {
                    cell.stackPrice.isHidden = false
                }
                if item.addOnPrices == "0" {
                    cell.stackAddOnPrice.isHidden = true
                }else {
                    cell.stackAddOnPrice.isHidden = false
                }
                if item.total == "0" {
                    cell.stackTotal.isHidden = true
                }else {
                    cell.stackTotal.isHidden = false
                }
            }
        }
        
        return cell
    }
}

extension OrderDetailVC:UITableViewDelegate {
    /**
    Asks the delegate for a view object to display in the header of the specified section of the table view.
    If there is cell with identifier headerCell, then return that cell else return empty UITableViewCell. The idenfier is passed in the Storyboard.
    */
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") else {
            return UITableViewCell()
        }
        return cell
    }
    
    /**
     Asks the delegate for the height to use for a row in a specified location.
    */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    /**
     Asks the delegate for the estimated height of a row in a specified location. Estimated height is 220.
     */
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220.0
    }
    
    /**
    Asks the delegate for the height to use for the header of a particular section. The height returned is 60
    */
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
}
