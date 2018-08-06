//
//  SalesReportVC.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 04/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

class SalesReportVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgDaily: UIImageView!
    @IBOutlet weak var imgWeekly: UIImageView!
    @IBOutlet weak var imgMonthly: UIImageView!
    @IBOutlet weak var lblDaily: UILabel!
    @IBOutlet weak var lblWeekly: UILabel!
    @IBOutlet weak var lblMonthly: UILabel!
    
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
    
    
    @IBAction func btnBackDidClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnStartDateDidClicked(_ sender: UIButton) {
    }
    
    @IBAction func btnEndDidClicked(_ sender: UIButton) {
    }
    
    @IBAction func btnDailyDidClicked(_ sender: UIButton) {
    }
    
    @IBAction func btnWeeklyDidClicked(_ sender: UIButton) {
    }
    
    @IBAction func btnMonthlyDidClicked(_ sender: UIButton) {
    }
}

extension SalesReportVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "salesReportCell") as? SalesReportCell else {
            return SalesReportCell()
        }
        return cell
    }
}

extension SalesReportVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
}
