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
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let onClick = onClick {
            lblName.text = onClick.customerName
            lblContact.text = onClick.contactNumber
            lblEmail.text = onClick.email
        }
        
        if let totalPrice = totalPrice {
            lblTotalAmount.text = "$" + totalPrice
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        
        initHudView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Global.isIpad {
            self.tableView.tableHeaderView?.frame.size.height = 200.0
        }
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
    
    @IBAction func btnBackDidClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAmountDidClicked(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.AmountVC) as! AmountVC
        if let onClick = onClick {
            vc.onClick = onClick
        }
        self.view.addSubview(vc.view)
        self.addChildViewController(vc)
    }
}

//MARK: ---------Table view datasorce---------

extension OrderDetailVC:UITableViewDataSource {
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
                }
                if item.modifier == "" {
                    cell.stackModifier.isHidden = true
                }
                if item.addOn == "" {
                    cell.stackAddOn.isHidden = true
                }
                if item.instruction == "" {
                    cell.stackInstruction.isHidden = true
                }
                if item.price == "0" {
                    cell.stackPrice.isHidden = true
                }
                if item.addOnPrices == "0" {
                    cell.stackAddOnPrice.isHidden = true
                }
                if item.total == "0" {
                    cell.stackTotal.isHidden = true
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
