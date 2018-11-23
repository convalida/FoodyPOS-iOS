//
//  CustomerDetailVC.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 20/11/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

class CustomerDetailVC: UIViewController {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var hudView = UIView()
    var customerDetails:CustomerDetail?
    var customerId:String = ""
    
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
        initHudView()
        getCustomerDetail()
    }

    func initHudView() {
        hudView.backgroundColor = UIColor.white
        self.view.addSubview(hudView)
        
        hudView.translatesAutoresizingMaskIntoConstraints = false
        hudView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        hudView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        hudView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        hudView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        MBProgressHUD.showAdded(to: hudView, animated: true)
        
        hudView.isHidden = true
    }
    
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
    
    @IBAction func btnBackDidClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension CustomerDetailVC:UITableViewDataSource {
    
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell") else {
            return UITableViewCell()
        }
        let lblNo = cell.contentView.viewWithTag(1) as! UILabel
        let btnTime = cell.contentView.viewWithTag(2) as! UIButton
        let btnPrice = cell.contentView.viewWithTag(3) as! UIButton
        let btnDetail = cell.contentView.viewWithTag(4) as! UIButton
        btnTime.tag = indexPath.row
        btnPrice.tag = indexPath.row
        btnDetail.tag = indexPath.row
        
        btnDetail.addTarget(self, action: #selector(btnDetailDidClicked(sender:)), for: .touchUpInside)
        btnPrice.addTarget(self, action: #selector(btnPriceDidClicked(sender:)), for: .touchUpInside)
        btnTime.addTarget(self, action: #selector(btnTimeDidClicked(sender:)), for: .touchUpInside)
        
        if let customer = customerDetails {
            if let customerDetail = customer.customer_Details {
                if let orderDetails = customerDetail.order_Details {
                    let order = orderDetails[indexPath.row]
                    if let orderNo = order.orderNo {
                        lblNo.text = "#" + orderNo
                    }
                }
            }
        }
        return cell
    }
    
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
    
    @objc func btnPriceDidClicked(sender:UIButton) {
        
    }
    
    @objc func btnDetailDidClicked(sender:UIButton) {
        if let customer = customerDetails {
            if let customerDetail = customer.customer_Details {
                if let orderDetails = customerDetail.order_Details {
                    let order = orderDetails[sender.tag]
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
