//
//  NotificationsVC.swift
//  FoodyPOS
//
//  Created by Minakshi Sadana on 18/10/19.
//  Copyright © 2019 com.tutist. All rights reserved.
//

import UIKit

class NotificationsVC: UIViewController {
   
    @IBOutlet weak var viewTop: UIView!
    
    @IBOutlet var tableView:UITableView!
    //let data: [String] = ["kirit", "kevin", "hitesh"]
    
    var notificationsData:Notifications?
    var hudView = UIView()
    
    struct CellIdentifier{
        static let NotificationCell="NotificationCell"
    }
    
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
        
        if(Global.isIpad){
            tableView.tableFooterView?.frame.size.height = 100
        }
  //     initHudView()
    //    callNotificationsAPI()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if(notificationsData == nil){
            callNotificationsAPI()
        }
    }
    
    @IBAction func btnBackDidClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initHudView(){
        hudView.backgroundColor = UIColor.white
        self.view.addSubview(hudView)
        hudView.translatesAutoresizingMaskIntoConstraints=false
        hudView.topAnchor.constraint(equalTo: viewTop.bottomAnchor).isActive = true
        hudView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        hudView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        hudView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        MBProgressHUD.showAdded(to: hudView, animated: true)
        hudView.isHidden = true
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            if self.tableView.numberOfRows(inSection: 0) > 0 {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .none, animated: true)
            }
        }
    }
    
    private func callNotificationsAPI(){
        guard let accountId = UserManager.acctId else{
           return
        }
        let parameterDic = ["AccountId":accountId]
       self.hudView.isHidden=false
        APIClient.notifications(parameters: parameterDic){ (result) in
            self.hudView.isHidden=true
          //  print(result)
            switch result{
            case .success(let notifications):
             //   print (notifications)
                self.notificationsData = notifications
                self.reloadTable()
                
            case .failure(let error):
                if(error.localizedDescription == noDataMessage || error.localizedDescription == noDataMessage1){
                self.showAlert(title: kAppName, message: AppMessages.msgFailed)
                }
                else{
                    self.showAlert(title: kAppName, message: error.localizedDescription)
                }
            }
        }
    }
    
    }
    




extension NotificationsVC:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSection=1
        
        let noDataLabel=UILabel(frame: CGRect(x:0, y:0, width:tableView.bounds.width, height:tableView.bounds.height))
        if let notificationsData = notificationsData{
        if notificationsData.notificationDetails.count == 0{
    //    if notificationsData == nil{
            tableView.tableFooterView?.isHidden=true
            noDataLabel.text = "No notifications found"
        } else{
            tableView.tableFooterView?.isHidden = false
            noDataLabel.text = ""
            }
        }
        else{
            noDataLabel.text = "No notifications found"
        }
        noDataLabel.textColor=UIColor.themeColor
        noDataLabel.textAlignment = .center
        tableView.backgroundView=noDataLabel
        
        return numberOfSection
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection:Int) ->Int{
        // return data.count
       // return 1
        if let notificationsData = notificationsData{
            return notificationsData.notificationDetails.count
        }
        return 0
    }
    
    func tableView(_ tableView:UITableView, cellForRowAt indexPath:IndexPath) ->UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.NotificationCell) as? NotificationCell else{
            return NotificationCell()
        }

        if let notificationsData = notificationsData {
            let dataNotification=notificationsData.notificationDetails[indexPath.row]
          //  if let notification1=dataNotification.
            
            cell.lblNotification.text=dataNotification!.message
            //cell.lblNotification.numberOfLines=2
            cell.lblTime.text=dataNotification!.orderDate+" "+dataNotification!.orderTime
        }
        
       // cell.lblTime?.text="7:00"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
        if let notificationsData = notificationsData?.notificationDetails[indexPath.row]{
            let orderNo = notificationsData.orderNo
         //       let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.OrderDetailVC) as! OrderDetailVC
           // vc.orderNo=notificationsData.orderNo
           // self.navigationController?.pushViewController(vc, animated: true)
           // }
          //  callOrderListAPI(orderNo: <#T##String#>)
            guard let restaurantId = UserManager.restaurantID else{
                return
            }
            let parameterDic = ["RestaurantId":restaurantId,
                                "startdate":"",
                                "enddate":"",
                                "ordernumber":orderNo]
             self.hudView.isHidden = false
            APIClient.orderSearch(paramters: parameterDic){(result) in
                self.hudView.isHidden = true
                switch result{
                case .success(let order):
                    if let resultCode = order.byOrderNumber.first?.resultCode{
                        if resultCode == "0"{
                            if let message = order.byOrderNumber.first?.message{
                                self.showToast(message)
                            }
                        }
                    }
                    else{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.OrderDetailVC) as! OrderDetailVC
                        vc.onClick = order.byOrderNumber.first?.onClick
                        vc.totalPrice = order.byOrderNumber.first?.totalPrices
                        self.navigationController?.pushViewController(vc, animated: true)
                       // Global.callReadNotificationApi(orderNo)
                    }
                case .failure(let error):
                    if (error.localizedDescription == noDataMessage || error.localizedDescription == noDataMessage1){
                        self.showAlert(title: kAppName, message: AppMessages.msgFailed)
                    }
                    else{
                        self.showAlert(title: kAppName, message: error.localizedDescription)
                    }
                }
                
            }
        }

        }
    }
  /**  public func callOrderListAPI(orderNo: String){
        guard let restaurantId = UserManager.restaurantID else{
            return
        }
        let parameterDic = ["RestaurantId":restaurantId,
                            "startdate":"",
                            "enddate":"",
                            "ordernumber":orderNo]
        self.hudView.isHidden = false
        APIClient.orderSearch(paramters: parameterDic){(result) in
            self.hudView.isHidden = true
            switch result{
            case .success(let order):
                if let resultCode = order.byOrderNumber.first?.resultCode{
                    if resultCode == "0"{
                                if let message = order.byOrderNumber.first?.message{
                                    self.showToast(message)
                        }
                    }
                }
                else{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.OrderDetailVC) as! OrderDetailVC
                    vc.onClick = order.byOrderNumber.first?.onClick
                    vc.totalPrice = order.byOrderNumber.first?.totalPrices
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                if (error.localizedDescription == noDataMessage || error.localizedDescription == noDataMessage1){
                    self.showAlert(title: kAppName, message: AppMessages.msgFailed)
                }
                else{
                    self.showAlert(title: kAppName, message: error.localizedDescription)
                }
            }
            
        }
    }
}**/

extension NotificationsVC:UITableViewDelegate{
    func tableView(_tableView:UITableView, heightForRowAt indexPath: IndexPath) ->CGFloat{
        return UITableViewAutomaticDimension
    }
    
    func tableView(_tableView:UITableView, estimatedHeightForRowAt indexPath: IndexPath) ->CGFloat{
        if(Global.isIpad){
            return 220.0
        }
        return 150.0
    }
}
