//
//  AmountVC.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 19/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

class AmountVC: UIViewController {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblTaxValue: UILabel!
    @IBOutlet weak var lblTaxPercentage: UILabel!
    @IBOutlet weak var lblTip: UILabel!
    @IBOutlet weak var lblGrandTotal: UILabel!
    
    var onClick:OnClick?
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideOnTap(recognizer:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }

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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func hideOnTap(recognizer:UITapGestureRecognizer) {
        removeController()
    }
    
    func removeController() {
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
}

extension AmountVC:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if self.mainView.frame.contains(touch.location(in: self.view)) {
            return false
        }
        return true
    }
}
