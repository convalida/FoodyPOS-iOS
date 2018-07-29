//
//  ChangePasswordVC.swift
//  FoodyPOS
//
//  Created by rajat on 28/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var txtOldPass: DesignTextField!
    @IBOutlet weak var txtNewPass: DesignTextField!
    @IBOutlet weak var txtConfirmPass: DesignTextField!
    
    //MARK: ---------View Life Cycle---------

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: ---------Button actions---------

    @IBAction func btnSubmitDidClicked(_ sender: UIButton) {
    }
    
    @IBAction func btnBackDidClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
