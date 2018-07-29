//
//  TopSaleVC.swift
//  FoodyPOS
//
//  Created by rajat on 29/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

class TopSaleVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    struct CellIdentifier {
        static let topSaleCell = "topSaleCell"
        static let seeAllCell = "seeAllCell"
    }
    
    //MARK: ---------View Life Cycle---------
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: ---------Button actions---------

    @IBAction func btnBackDidClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension TopSaleVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let totalRows = tableView.numberOfRows(inSection: 0)
        if indexPath.row != totalRows-1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.topSaleCell) as? TopSaleCell else {
                return TopSaleCell()
            }
            return cell
        }else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.seeAllCell) as? TopSaleCell else {
                return TopSaleCell()
            }
            return cell
         }
    }
}

extension TopSaleVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let totalRows = tableView.numberOfRows(inSection: 0)
        if indexPath.row != totalRows-1 {
            return 150.0
        }else {
            return 71
        }
    }
}
