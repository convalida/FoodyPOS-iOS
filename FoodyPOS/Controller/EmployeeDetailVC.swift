//
//  EmployeeDetailVC.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 04/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

class EmployeeDetailVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the
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
    
    @IBAction func btnAddEmployeeDidClicked(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.SignUpVC) as! SignUpVC
        self.view.addSubview(vc.view)
        self.addChildViewController(vc)
        
    }
    
    @objc func btnEditDidClicked(sender:UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.EditEmployeeVC) as! EditEmployeeVC
        self.view.addSubview(vc.view)
        self.addChildViewController(vc)
    }
}

extension EmployeeDetailVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "employeeDetailCell") as? EmployeeDetailCell else {
            return EmployeeDetailCell()
        }
        cell.btnEdit.addTarget(self, action: #selector(btnEditDidClicked(sender:)), for: .touchUpInside)
        return cell
    }
}

extension EmployeeDetailVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
    }
}
