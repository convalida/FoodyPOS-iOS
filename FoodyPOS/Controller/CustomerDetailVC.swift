//
//  CustomerDetailVC.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 20/11/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

/**View controller class for Customer details or customer history section called when customer name is clicked in TopSaleVC, SalesSellAllVC, OrderDetailVC. 
Rajat ji please check this and also if it is called from some other controller also 
*/
class CustomerDetailVC: UIViewController {

    ///Outlet for name text field
    @IBOutlet weak var lblName: UILabel!
    ///Outlet for contact no. text field
    @IBOutlet weak var lblNumber: UILabel!
    ///Outlet for email text field
    @IBOutlet weak var lblEmail: UILabel!
    ///Outlet for table view
    @IBOutlet weak var tableView: UITableView!
    ///Outlet for navigation bar
    @IBOutlet weak var viewTop: UIView!
    ///Outlet for main view, i.e., complete screen
    @IBOutlet weak var mainView: UIView!
    
    ///Instantiate hud view
    var hudView = UIView()
    ///Declare variable for CustomerDetail structure
    var customerDetails:CustomerDetail?
    ///Instantiate customerId string to null
    var customerId:String = ""
    
     ///Display status bar
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
     ///Set light content of status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    /**
     Life cycle method called after view is loaded. Set data source and delegate of table view to self. Call initHudView method
     which initializes the hud view. Call getCustomerDetail method which hits customer detail web service
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        initHudView()
        getCustomerDetail()
    }

    /**
    Called before the view is loaded. If device is iPad, set height of table header view to 140. Header view is the section for name, contact and email id. Rajat ji please check this.
    */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Global.isIpad {
            self.tableView.tableHeaderView?.frame.size.height = 140.0
        }
    }
    
    /**
    Initialize hud view. Set background color to white and hud view as sub view. Set constraints to top, left, bottom and right of hud view, add hud view and hide it.
    */
    func initHudView() {
        hudView.backgroundColor = UIColor.white
        self.view.addSubview(hudView)
        
        hudView.translatesAutoresizingMaskIntoConstraints = false
        hudView.topAnchor.constraint(equalTo: self.viewTop.bottomAnchor).isActive = true
        hudView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        hudView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        hudView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        MBProgressHUD.showAdded(to: hudView, animated: true)
        
        hudView.isHidden = true
    }
    
    /**
    Method called when customer details api hit is successful. If customerDetails is not null. If customer_Details is not null, 
    if name in customer_details is not null, set name in corresponding text field,  if contactNo in customer_details is not null, set contact no. in corresponding text field,
     if email in customer_details is not null, set email corresponding text field,
    */
    func initData() {
        if let customer = customerDetails {
            if let details = customer.customer_Details {
                if let name = details.name {
                    self.lblName.text = name
                }
                if let contactNo = details.contactNo {
                    self.lblNumber.text = contactNo
                }
                if let email = details.customerEmail {
                    self.lblEmail.text = email
                }
            }
        }
    }
    
    /**
    Method called in viewDidLoad method and is reponsible for hitting customer details web service. If UserManager class does not have restaurant id, return.
    Take parameter restaurant id from UserManager class, customer id from controller which is calling CustomerDetailVC like SalesSellVC, OrderDetailVC and TopSaleVC. Rajat ji please check this.
    Display hud view. Call method customerDetails from APIClient class passing the parameters. Hide hud view. If api hit is successful,
    put response customerDetails. Rajat ji please check this. Call initData method which sets customer name, email id and phone no. to corresponding text fields.
    Call reloadData method on table view which reloads the rows and sections of the table view.
    If api hit is not successful, if error message is noDataMessage or noDataMessage1 in Constants.swift, display message msgFailed in AppMessages.swift in dialog else display error message in dialog.   
    */
    func getCustomerDetail() {
        guard let restaurentId = UserManager.restaurantID else {
            return
        }
        let parameter = ["RestaurantId":restaurentId,
                         "CustomerId":customerId]
        self.hudView.isHidden = false
        APIClient.customerDetails(paramters: parameter) { (result) in
            self.hudView.isHidden = true
            switch result {
            case .success(let data):
                self.customerDetails = data
                self.initData()
                self.tableView.reloadData()
                
            case .failure(let error):
                if error.localizedDescription == noDataMessage || error.localizedDescription == noDataMessage1 {
                    self.showAlert(title: kAppName, message: AppMessages.msgFailed)
                } else {
                    self.showAlert(title: kAppName, message: error.localizedDescription)
                }
            }
        }
    }
    
    /**
     When back button is clicked, pop the top view controller from navigation stack and update the display.
     */
    @IBAction func btnBackDidClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension CustomerDetailVC:UITableViewDataSource {
    
    /**
    Method returns no. of sections of table view. Set noDataLbl's width and height of table view. If customerDetails is not null, 
    if customer_Details inside customerDetails is not null, if order_Details inside customer_Details is not null, if count of orderDetails is 0, set noDataLbl text to No data found.
    If count of orderDetails is not 0, set noDataLbl text to null. Set noDataLbl text color to theme color and its alignment to center.
    Set background of table view to noDataLbl. Return no. of sections 1
    */
    func numberOfSections(in tableView: UITableView) -> Int {
        let noDataLbl = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
        if let customer = customerDetails {
            if let customerDetail = customer.customer_Details {
                if let orderDetails = customerDetail.order_Details {
                        if orderDetails.count == 0 {
                            noDataLbl.text = "No data found"
                        }else {
                            noDataLbl.text = ""
                        }
                        noDataLbl.textColor = UIColor.themeColor
                        noDataLbl.textAlignment = .center
                        tableView.backgroundView = noDataLbl
                        return 1
                }
            }
        }
        return 0
    }

       /**
       This method returns no. of rows in section of table view. If customerDetails structure is not null, if customer_Details in cusdtomerDetails
       is not null, if order_Details in customer_Details is not null. Rajat ji please check this, will update at other places it is used accordingly.
       Return count of order_Details. Return 0 by default
       */ 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let customer = customerDetails {
            if let customerDetail = customer.customer_Details {
                if let orderDetails = customerDetail.order_Details {
                    return orderDetails.count
                }
            }
        }
        return 0
    }
    
    /**
    This method asks the data source for a cell to insert in a particular location of the table view.
    Set cell to EmployeeDetailCell if cell identifier is employeeDetailCell, else set cell to empty EmployeeDetailCell (default case which happens rarely).
    Set tag to btnTime, btnPrice and btnDetail to specified index of row, so as to use that value to identify the view later. Rajat ji please check this.
    Set listeners to btnDetail, btnPrice, btnTime to call methods btnDetailDidClicked, btnPriceDidClicked, btnTimeDidClicked resp. Rajat ji please check this.
    btnPriceDidClicked is not used. If customerDetails structure is not null, if customer_Details in cusdtomerDetails
    is not null, if order_Details in customer_Details is not null, get orderDetails at each index of row.
    If order no. at particular index is not null, set order no. to specified text field concatenated with # symbol.
    If price at particular index is not null, set price to specified text field concatenated with $ symbol.
    Return the cell

    */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell") as? CustomerOrderCell else {
            return UITableViewCell()
        }

        cell.btnTime.tag = indexPath.row
        cell.btnPrice.tag = indexPath.row
        cell.btnDetail.tag = indexPath.row
        
        cell.btnDetail.addTarget(self, action: #selector(btnDetailDidClicked(sender:)), for: .touchUpInside)
        cell.btnPrice.addTarget(self, action: #selector(btnPriceDidClicked(sender:)), for: .touchUpInside)
        cell.btnTime.addTarget(self, action: #selector(btnTimeDidClicked(sender:)), for: .touchUpInside)
        
        if let customer = customerDetails {
            if let customerDetail = customer.customer_Details {
                if let orderDetails = customerDetail.order_Details {
                    let order = orderDetails[indexPath.row]
                    if let orderNo = order.orderNo {
                        cell.lblNo.text = "#" + orderNo
                    }
                    if let price = order.total {
                        cell.btnPrice.setTitle("$" + price, for: .normal)
                    }
                }
            }
        }
        return cell
    }
    
     /**
     Asks the delegate for the height to use for a row in a specified location. Return height 44
    */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    /**
    Method called when time button in row is clicked. If customerDetails structure is not null, if customer_Details in cusdtomerDetails
    is not null, if order_Details in customer_Details is not null. Get tag of orderDetails. Rajat ji please check this.
    Instantiate DateVC. If orderPickupDate in orderDetails is not null, pass orderPickupDate to vc. If orderTime in orderDetails is not null, 
    pass orderTime to vc. Add view as sub view of view controller and add DateVC as child view controller
    */
    @objc func btnTimeDidClicked(sender:UIButton) {
        if let customer = customerDetails {
            if let customerDetail = customer.customer_Details {
                if let orderDetails = customerDetail.order_Details {
                    let order = orderDetails[sender.tag]
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.DateVC) as! DateVC
                    if let date = order.orderPickupDate {
                        vc.date = date
                    }
                    if let time = order.orderTime {
                        vc.time = time
                    }
                    self.view.addSubview(vc.view)
                    self.addChildViewController(vc)
                }
            }
        }
    }
    
    ///Not used
    @objc func btnPriceDidClicked(sender:UIButton) {
        
    }
    
    /**
    Method called when detail button (right arrow) is clicked. Rajat ji please check this.
    Call method showOrderDetailForTag and pass the tag or identifier. Rajat ji please check this.
    which launches OrderDetailVC
    */
    @objc func btnDetailDidClicked(sender:UIButton) {
        showOrderDetailForTag(tag: sender.tag)
    }
    
    /**
    Method called when detail button is clicked. If customerDetails structure is not null, if customer_Details in cusdtomerDetails
    is not null, if order_Details in customer_Details is not null, get the identifier of orderDetails to fetch which order was clicked. Rajat ji please check this.
    If orderNo in clicked order is not null, instantiate OrderDetailVC and pass order no. thus obtained to vc and push vc.
    */
    func showOrderDetailForTag(tag:Int) {
        if let customer = customerDetails {
            if let customerDetail = customer.customer_Details {
                if let orderDetails = customerDetail.order_Details {
                    let order = orderDetails[tag]
                    if let orderNo = order.orderNo {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.OrderDetailVC) as! OrderDetailVC
                        vc.orderNo = orderNo
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
}

extension CustomerDetailVC: UITableViewDelegate {
    /**
    Tells the delegate that the specified row is now selected. Call method showOrderDetailTag and pass index of row in it which launches OrderDetailVC.
    Rajat ji kindly check if OrderDetailVC is launched both in cases when detail button is clicked and anywhere in row of CustomerDetails is clicked.
    */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showOrderDetailForTag(tag: indexPath.row)
    }
}
