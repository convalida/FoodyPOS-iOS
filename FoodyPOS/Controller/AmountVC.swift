//
//  AmountVC.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 19/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

///View controller class for Amount dialog, called when amount section is clicked on OrderDetailVC
class AmountVC: UIViewController {
    ///Outlet for main view, i.e., complete dialog
    @IBOutlet weak var mainView: UIView!
    ///Outlet for sub total
    @IBOutlet weak var lblSubTotal: UILabel!
    ///Outlet for tax value
    @IBOutlet weak var lblTaxValue: UILabel!
    ///Outlet for tax percentage
    @IBOutlet weak var lblTaxPercentage: UILabel!
    ///Outlet for tip
    @IBOutlet weak var lblTip: UILabel!
    ///Outlet for grand total
    @IBOutlet weak var lblGrandTotal: UILabel!
    
    ///Declare variable for OnCLick structure
    var onClick:OnClick?
    
     ///Display status bar
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    ///Set light color of status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
     /**
     Life cycle method called after view is loaded. Remove the controller, on tap of view using UITapGestureRecognizer which is a pre defined class and call addGestureRecognizer which is a pre defined method.
     Add delegate of tap to self. Initalize hud view
 */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideOnTap(recognizer:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }

    /**
    Called before the view is loaded. Set opacity of dialog background. (Area behind the alert dialog, covering the screen)
     If onClick is not null, set value of tip in onClick to corresponding text field, concatenating with $,
     set value of subTotal in onClick to corresponding text field, concatenating with $, set value of tax value in onClick to corresponding text field, concatenating with $,
     set value of grand total in onClick to corresponding text field, concatenating with $, set value of tax percentage in onClick to corresponding text field, concatenating with Tax before percentage and % after percentage,
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        if let onClick = onClick {
            lblTip.text = "$" + onClick.tip!
            lblSubTotal.text = "$" + onClick.subTotal!
            lblTaxValue.text = "$" + onClick.taxvalue!
            lblGrandTotal.text = "$" + onClick.grandTotal!
            lblTaxPercentage.text = "Tax(\(onClick.taxInPercentage!)%):"
        }
    }
    
     /// Dispose off any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

     /**
    On tap, controller is removed using UITapGestureRecognizer which is a pre defined class
     */
    @objc func hideOnTap(recognizer:UITapGestureRecognizer) {
        removeController()
    }
    
     /**
 Removes a controller from superview and parent view controller.
 */
    func removeController() {
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
}

extension AmountVC:UIGestureRecognizerDelegate {
    /**
     To disable touch effect on alert dialog background area
     */
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if self.mainView.frame.contains(touch.location(in: self.view)) {
            return false
        }
        return true
    }
}
