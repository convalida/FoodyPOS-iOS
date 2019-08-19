//
//  BestSellerVC.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 04/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit
///View controller class for BestSeller screen
class BestSellerVC: UIViewController {

    ///Outlet for table view
    @IBOutlet weak var tableView: UITableView!
    ///Outlet for navigation bar
    @IBOutlet weak var viewTop: UIView!

    ///Declare variable for BestSeller structure
    var bestSellerData:BestSeller?
    ///Instantiate hud view
    var hudView = UIView()
    
    ///Set status bar to visible 
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
     ///Set light content of status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: View life cycle
    /**
    Life cycle method called after view is loaded. Set delegate and data source of table view to self. Call initHudView method which initializes the hud view
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        initHudView()
    }

    /**
    Called before the view is loaded. If bestSellerData is null, i.e., it is called for first time.
    Call method getBestSellerData method which hits bestseller iteems web service.
    */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if bestSellerData == nil {
            getBestSellerData()
        }
    }
    
     /// Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
    Initialize hud view. Set background color to white and hud view as sub view. Set constraints to top, left, bottom and right of hud view, add hud view and hide it.
    */
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
    
    //MARK: Button Actions
    ///Back button clicked. Pop the top view controller from stack
    @IBAction func btnBackDidClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //Reload table
    /**
     This method is called in getBestSellerData method when api hit is successful. Reload rows and sections of table view. 
    */
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    /**
    This method is called inside viewWillAppear method and is responsible for hitting bestseller items web service.
    If restaurant id in UserManager class is null, then return. Take parameter restaurant id from Usermanager class.
    Dsiplay hud view. Call bestSellerItems method in APIClient method, passing the parameters. Hide hud view.
    If api hit is successful,  print response in logs., set response to bestSellerData and call reloadTable mertthod which reloads rows and sections of table view.
    If api hit is not successful, if error message is noDataMessage or noDataMessage1 in Constants.swift, display message msgFailed in AppMessages.swift in dialog else display error message in dialog.
    */
    private func getBestSellerData() {
        guard let restaurentId = UserManager.restaurantID else {
            return
        }
        let prameterDic = ["RestaurantId":restaurentId]
        
        self.hudView.isHidden = false
        APIClient.bestSellerItems(paramters: prameterDic) { (result) in
            self.hudView.isHidden = true
            switch result {
            case .success(let bestSeller):
                print(bestSeller)
                self.bestSellerData = bestSeller
                self.reloadTable()
                
            case .failure(let error):
                if error.localizedDescription == noDataMessage || error.localizedDescription == noDataMessage1 {
                    self.showAlert(title: kAppName, message: AppMessages.msgFailed)
                }else {
                    self.showAlert(title: kAppName, message: error.localizedDescription)
                }
            }
        }
    }
}

extension BestSellerVC:UITableViewDataSource {
    /**
    This method returns no. of sections. Initialize no. of sections to 1. Set width and height of noDataLbl to width and height of table view. 
    If bestsellerData is null, set noDataLbl text to No bestsellers found else set noDataLbl text to null.
    Set noDataLbl text color to theme color, its alignment to center, set background to tableview to noDataLbl.
    Return no. of sections
    */
    func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSection = 1
        
        let noDataLbl = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
        if bestSellerData == nil {
            noDataLbl.text = "No bestsellers found"
        }else {
            noDataLbl.text = ""
        }
        noDataLbl.textColor = UIColor.themeColor
        noDataLbl.textAlignment = .center
        tableView.backgroundView = noDataLbl
        
        return numberOfSection
    }
    
    /**
     This method returns no. of rows in section. If bestsellerData is not null, return no. of rows 3, return no. of rows 0 in all other cases.
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if bestSellerData != nil {
            return 3
        }
        return 0
    }
    
    /**
     This method asks the data source for a cell to insert in a particular location of the table view.
     Set cell to BestSellerCell if cell identifier is bestSellerCell, else set cell to empty BestSellerCell (default case which happens rarely).
    Define method setDefault which is called when no. of items weekly, monthly or yearly best seller items is null.
    It sets item 1, value 1, value 2, item 3, value 3 to null, item 2 text to No items and its alignment to center.
    If bestSellerData is null, for 0th row, set text to Weekly Bestseller Items. If count of weeklyBestseller items in bestsellerData is greater than 0,
    if count of weeklyBestseller items in bestsellerData is greater than or equal to 1, if item at 0th position of weeklyBestSellerItem is not null, set sub item and counting to item 1 and value 1 text field resp. in cell.       
    if count of weeklyBestseller item is less than 1, set item 1 and value 1 text field to null.
    If count of weeklyBestseller items in bestsellerData is greater than or equal to 2,
    if item at 1st position of weeklyBestSellerItem is not null, set sub item and counting to item 2 and value 2 text field resp. in cell.       
    if count of weeklyBestseller item is less than 2, set item 2 and value 2 text field to null.
    If count of weeklyBestseller items in bestsellerData is greater than or equal to 3,
    if item at 2nd position of weeklyBestSellerItem is not null, set sub item and counting to item 3 and value 3 text field resp. in cell.       
    if count of weeklyBestseller item is less than 3, set item 3 and value 3 text field to null.
    If count of weeklyBestseller item is 0, call method setDefault which sets all text fields to null except item 2 which displays No items at center.

    For 1st row, set text to Monthly Bestseller Items. If count of monthlyBestseller items in bestsellerData is greater than 0,
    if count of monthlyBestseller items in bestsellerData is greater than or equal to 1, if item at 0th position of monthlyBestSellerItem is not null, set sub item and counting to item 1 and value 1 text field resp. in cell.       
    if count of monthlyBestseller item is less than 1, set item 1 and value 1 text field to null.
    If count of monthlyBestseller items in bestsellerData is greater than or equal to 2,
    if item at 1st position of monthlyBestSellerItem is not null, set sub item and counting to item 2 and value 2 text field resp. in cell.       
    if count of monthlyBestseller item is less than 2, set item 2 and value 2 text field to null.
    If count of monthlyBestseller items in bestsellerData is greater than or equal to 3,
    if item at 2nd position of monthlyBestSellerItem is not null, set sub item and counting to item 3 and value 3 text field resp. in cell.       
    if count of monthlyBestseller item is less than 3, set item 3 and value 3 text field to null.
    If count of monthlyBestseller item is 0, call method setDefault which sets all text fields to null except item 2 which displays No items at center.

    For 2nd row, set text to Yearly Bestseller Items. If count of yearlyBestseller items in bestsellerData is greater than 0,
    if count of yearlyBestseller items in bestsellerData is greater than or equal to 1, if item at 0th position of yearlyBestSellerItem is not null, set sub item and counting to item 1 and value 1 text field resp. in cell.       
    if count of yearlyBestseller item is less than 1, set item 1 and value 1 text field to null.
    If count of yearlyBestseller items in bestsellerData is greater than or equal to 2,
    if item at 1st position of yearlyBestSellerItem is not null, set sub item and counting to item 2 and value 2 text field resp. in cell.       
    if count of yearlyBestseller item is less than 2, set item 2 and value 2 text field to null.
    If count of yearlyBestseller items in bestsellerData is greater than or equal to 3,
    if item at 2nd position of yearlyBestSellerItem is not null, set sub item and counting to item 3 and value 3 text field resp. in cell.       
    if count of yearlyBestseller item is less than 3, set item 3 and value 3 text field to null.
    If count of yearlyBestseller item is 0, call method setDefault which sets all text fields to null except item 2 which displays No items at center.
    In default case, print default in logs.

    Set position of row to tag for btnAll in cell.
    Set listener to btnAll and return cell.
    */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bestSellerCell") as? BestSellerCell else {
            return BestSellerCell()
        }
        
        func setDefault() {
            cell.lblItem1.text = ""
            cell.lblValue1.text = ""
            cell.lblItem2.text = "       No Items"
            cell.lblItem2.textAlignment = .center
            cell.lblValue2.text = ""
            cell.lblItem3.text = ""
            cell.lblValue3.text = ""
        }
        
        if let bestSellerData = bestSellerData {
            switch indexPath.row {
            case 0:
                cell.lblTitle.text = "Weekly Bestseller Items"
                if bestSellerData.weeklyBestsellersItem.count > 0 {
                    if bestSellerData.weeklyBestsellersItem.count >= 1 {
                        if let item1 = bestSellerData.weeklyBestsellersItem[0] {
                            cell.lblItem1.text = item1.subitems
                            cell.lblValue1.text = item1.counting
                        }
                    }else {
                        cell.lblItem1.text = ""
                        cell.lblValue1.text = ""
                    }
                    
                    
                    if bestSellerData.weeklyBestsellersItem.count >= 2 {
                        if let item2 = bestSellerData.weeklyBestsellersItem[1] {
                            cell.lblItem2.text = item2.subitems
                            cell.lblValue2.text = item2.counting
                        }
                    }else {
                        cell.lblItem2.text = ""
                        cell.lblValue2.text = ""
                    }

                    if bestSellerData.weeklyBestsellersItem.count >= 3 {
                        if let item3 = bestSellerData.weeklyBestsellersItem[2] {
                            cell.lblItem3.text = item3.subitems
                            cell.lblValue3.text = item3.counting
                        }
                    }else {
                        cell.lblItem3.text = ""
                        cell.lblValue3.text = ""
                    }
                }else {
                    setDefault()
                }
                
            case 1:
                cell.lblTitle.text = "Monthly Bestseller Items"
                if bestSellerData.monthelyBestsellersItem.count > 0 {
                    if bestSellerData.monthelyBestsellersItem.count >= 1 {
                        if let item1 = bestSellerData.monthelyBestsellersItem[0] {
                            cell.lblItem1.text = item1.subitems
                            cell.lblValue1.text = item1.counting
                        }
                    }else {
                        cell.lblItem1.text = ""
                        cell.lblValue1.text = ""
                    }
                    
                    
                    if bestSellerData.monthelyBestsellersItem.count >= 2 {
                        if let item2 = bestSellerData.monthelyBestsellersItem[1] {
                            cell.lblItem2.text = item2.subitems
                            cell.lblValue2.text = item2.counting
                        }
                    }else {
                        cell.lblItem2.text = ""
                        cell.lblValue2.text = ""
                    }
                    
                    if bestSellerData.monthelyBestsellersItem.count >= 3 {
                        if let item3 = bestSellerData.monthelyBestsellersItem[2] {
                            cell.lblItem3.text = item3.subitems
                            cell.lblValue3.text = item3.counting
                        }
                    }else {
                        cell.lblItem3.text = ""
                        cell.lblValue3.text = ""
                    }
                }else {
                    setDefault()
                }
                
            case 2:
                cell.lblTitle.text = "Yearly Bestseller Items"
                if bestSellerData.yearlyBestsellersItem.count > 0 {
                    if bestSellerData.yearlyBestsellersItem.count >= 1 {
                        if let item1 = bestSellerData.yearlyBestsellersItem[0] {
                            cell.lblItem1.text = item1.subitems
                            cell.lblValue1.text = item1.counting
                        }
                    }else {
                        cell.lblItem1.text = ""
                        cell.lblValue1.text = ""
                    }
                    
                    
                    if bestSellerData.yearlyBestsellersItem.count >= 2 {
                        if let item2 = bestSellerData.yearlyBestsellersItem[1] {
                            cell.lblItem2.text = item2.subitems
                            cell.lblValue2.text = item2.counting
                        }
                    }else {
                        cell.lblItem2.text = ""
                        cell.lblValue2.text = ""
                    }
                    
                    if bestSellerData.yearlyBestsellersItem.count >= 3 {
                        if let item3 = bestSellerData.yearlyBestsellersItem[2] {
                            cell.lblItem3.text = item3.subitems
                            cell.lblValue3.text = item3.counting
                        }
                    }else {
                        cell.lblItem3.text = ""
                        cell.lblValue3.text = ""
                    }
                }else {
                    setDefault()
                }
                
            default:
                print("Default")
            }
        }
        cell.btnAll.tag = indexPath.row
        cell.btnAll.addTarget(self, action: #selector(btnAllDidClicked(sender:)), for: .touchUpInside)
        return cell
    }
    
    /**
    Method called when See all button is clicked. Instantiate AllBestSellerVC. If tag of button is 0, sety type to week, if tag of button is 1, set type to month,
    if tag of button is 2, set type to year, pass type with vc and push vc.
    */
    @objc func btnAllDidClicked(sender:UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardConstant.AllBestSellerVC) as! AllBestSellerVC
        if sender.tag == 0 {
            vc.type = "week"
        } else if sender.tag == 1 {
            vc.type = "month"
        } else if sender.tag == 2 {
            vc.type = "year"
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension BestSellerVC:UITableViewDelegate {
    /**
    Asks the delegate for the height to use for a row in a specified location. Return a constant representing the default value for a given dimension
    */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    /**
    Asks the delegate for the estimated height of a row in a specified location. If device is iPad, return 200 else return 150.
    */
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if Global.isIpad {
            return 200.0
        }
        return 150.0
    }
}
