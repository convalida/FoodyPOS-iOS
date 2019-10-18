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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnBackDidClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func tableView(_tableView:UITableView, heightForRowAt indexPath: IndexPath) ->CGFloat{
        return 40
    }
    
    func tableView(_tableView:UITableView, numberOfRowsInSection:Int) ->Int{
      // return data.count
        return 4
    }
    
    func tableView(_tableView:UITableView, cellForRowAt indexPath:IndexPath) ->UITableViewCell{
        let cell:NotificationCell=tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as!NotificationCell
        return cell
    }

}
