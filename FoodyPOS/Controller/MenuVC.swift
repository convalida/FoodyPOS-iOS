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
