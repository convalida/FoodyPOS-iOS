//
//  OrderListVC.swift
//  FoodyPOS
//
//  Created by rajat on 31/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

struct CellData {
    var isOpened = Bool()
    var date = String()
    var sectionData = [String]()
}

class OrderListVC: UIViewController {
    @IBOutlet weak var lblTotalOrders: UILabel!
    @IBOutlet weak var lblTotalAmounts: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewSearch: UIView!
    
    var tableViewData = [CellData]()

    //MARK: ---------View Life Cycle---------
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        tableViewData = [CellData(isOpened: false, date: "title1", sectionData: ["cell1","cell2","cell3"]),CellData(isOpened: false, date: "title2", sectionData: ["cell1","cell2","cell3"]),CellData(isOpened: false, date: "title3", sectionData: ["cell1","cell2","cell3"])]

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: ---------Button actions---------
    @IBAction func btnDateStartDidClicked(_ sender: UIButton) {
    }
    
    @IBAction func btnDateEndDidClicked(_ sender: UIButton) {
    }
   
    @IBAction func btnDateSearchDidClicked(_ sender: UIButton) {
    }
    
    @IBAction func btnSearchBarDidClicked(_ sender: UIButton) {
    }
    
    @IBAction func btnBackDidClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: ---------Table view datasorce---------

extension OrderListVC:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].isOpened {
            return tableViewData[section].sectionData.count + 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as? OrderListCell else {
                return OrderListCell()
            }
            //cell.textLabel?.text = tableViewData[indexPath.section].title
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as? OrderListCell else {
                return OrderListCell()
            }
            //cell.textLabel?.text = tableViewData[indexPath.section].sectionData[indexPath.row - 1]
            return cell
        }
    }
}

//MARK: ---------Table view delegate---------
extension OrderListVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if tableViewData[indexPath.section].isOpened {
                tableViewData[indexPath.section].isOpened = false
            }else {
                tableViewData[indexPath.section].isOpened = true
            }
            let sections = IndexSet(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
        }
    }
}
