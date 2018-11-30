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
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var mainView: UIView!
    
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
        tableView.delegate = self
        initHudView()
        getCustomerDetail()
    }

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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
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
        showOrderDetailForTag(tag: sender.tag)
    }
    
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showOrderDetailForTag(tag: indexPath.row)
    }
}
