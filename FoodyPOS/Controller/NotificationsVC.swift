//
//  NotificationsVC.swift
//  FoodyPOS
//
//  Created by Minakshi Sadana on 18/10/19.
//  Copyright © 2019 com.tutist. All rights reserved.
//

import UIKit

class NotificationsVC: UIViewController {
    @IBOutlet var tableView:UITableView!
    //let data: [String] = ["kirit", "kevin", "hitesh"]
    @IBOutlet weak var viewTop: UIView!
    
    
    override var prefersStatusBarHidden: Bool{
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource=self
        tableView.delegate=self

        // Do any additional setup after loading the view.
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
        super.viewWillAppear(true)
    }
    
    @IBAction func btnBackDidClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    }
    
    



extension NotificationsVC:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection:Int) ->Int{
        // return data.count
        return 1
    }
    
    func tableView(_ tableView:UITableView, cellForRowAt indexPath:IndexPath) ->UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as?NotificationCell else{
            return NotificationCell()
        }
        cell.lblNotification?.text="Notification"
       // cell.lblTime?.text="7:00"
        return cell
    }
    
}

extension NotificationsVC:UITableViewDelegate{
    func tableView(_tableView:UITableView, heightForRowAt indexPath: IndexPath) ->CGFloat{
        return 40
    }
}
