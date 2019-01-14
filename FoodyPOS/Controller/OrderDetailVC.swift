//
//  OrderDetailVC.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 17/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit
struct OrderDetail {
    let key:String
    let value:String
}

class OrderDetailVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblContact: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var viewTop: UIView!

    var onClick:OnClick?
    var totalPrice:String?
    var hudView = UIView()
    var orderNo = ""
    var startDate:String?
    var endDate:String?
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Global.isIpad {
            self.tableView.tableHeaderView?.frame.size.height = 200.0
        }
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveOrderNumber(notification:)), name: NSNotification.Name(rawValue: kOrderDetailNotification), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    @IBAction func btnBackDidClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func viewAmountDidClicked(_ sender: UITapGestureRecognizer) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.AmountVC) as! AmountVC
        if let onClick = onClick {
            vc.onClick = onClick
        }
        self.view.addSubview(vc.view)
        self.addChildViewController(vc)        
    }
    
    
    @IBAction func btnAmountDidClicked(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.AmountVC) as! AmountVC
        if let onClick = onClick {
            vc.onClick = onClick
        }
        self.view.addSubview(vc.view)
        self.addChildViewController(vc)
    }
    
    @IBAction func btnCustomerDetailDidClicked(_ sender: UIButton) {
         if let onClick = onClick {
            if let customerId = onClick.customerId {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.CustomerDetailVC) as! CustomerDetailVC
                vc.customerId = customerId
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let onClick = onClick {
            if let orderItems = onClick.orderItemDetails {
                return orderItems.count
            }
        }
        return 0
    }
    
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
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") else {
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
}
