//
//  MenuVC.swift
//  FoodyPOS
//
//  Created by Minakshi Sadana on 09/09/19.
//  Copyright © 2019 com.tutist. All rights reserved.
//

import UIKit

class MenuVC: UIViewController {

    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var textSearch: DesignTextField!
    @IBOutlet weak var tableView: UITableView!
    ///Instantiate hud view
    var hudView = UIView()
    
    ///Display status bar
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    ///Set light color of status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
          tableView.dataSource = self
        // Do any additional setup after loading the view.
          //  tableView.delegate = self
          //  tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewSearch.isHidden=true
    }

    @IBAction func btnBackDidClicked(_ sender: UIButton) {
self.navigationController?.popViewController(animated: true)
    }

   
    @IBAction func btnSearchDidClicked(_ sender: UIButton) {
        if viewSearch.isHidden{
            textSearch.text=""
            sender.isSelected = true
            viewSearch.isHidden=false
            textSearch.becomeFirstResponder()
        }
    }
    
    
    @IBAction func btnSearchBackDidClicked(_ sender: Any) {
        viewSearch.isHidden=true
        textSearch.resignFirstResponder()
    }
}


extension MenuVC:UITableViewDataSource {
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        }
        
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as? OrderListCell else {
            return OrderListCell()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      //  if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as? OrderListCell else {
                return OrderListCell()
            }
        return cell
    }
    }
extension MenuVC:UITableViewDelegate{

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if Global.isIpad {
            return 80.0
        }
        return 44.0
    }
    
}



