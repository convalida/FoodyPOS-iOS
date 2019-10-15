//
//  TopSaleCell.swift
//  FoodyPOS
//
//  Created by rajat on 29/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

/**
This class is used for creating view inside cell in TopSaleVC and SalesSellVC.
*/
class TopSaleCell: UITableViewCell {

    ///Outlet for first letter of customer name from Sale structure or Customer structure in TopSaleVC and SalesSellVC
    @IBOutlet weak var lblLetter: UILabel!
    ///Outlet for customer name from Sale structure or Customer structure in TopSaleVC and SalesSellVC 
    @IBOutlet weak var lblName: UILabel!
    ///Outlet for contact no. from Sale structure or Customer structure in TopSaleVC and SalesSellVC.
    @IBOutlet weak var btnPhone: UIButton!
     ///Outlet for no. of orders from Sale structure or Customer structure in TopSaleVC and SalesSellVC
    @IBOutlet weak var lblOrder: UILabel!
     ///Outlet for total price of all orders of customer from Sale structure or Customer structure in TopSaleVC and SalesSellVC
    @IBOutlet weak var lblPrice: UILabel!
    
    /**
     Prepares the receiver for service after it has been loaded from an Interface Builder archive, or nib file.
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

     /**
    Sets the selected state of the cell, optionally animating the transition between states.
    */
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
