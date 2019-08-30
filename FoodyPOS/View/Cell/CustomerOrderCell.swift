//
//  CustomerOrderCell.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 30/11/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

/**
This class is used for creating view inside cell in CustomerDetailVC.
*/
class CustomerOrderCell: UITableViewCell {

    ///Outlet for time button on click of with opens a dialog with date and time
    @IBOutlet weak var btnTime: UIButton!
    ///Outlet for price button which displays price of order concatenated with $ sign, on click of which nothing happens
    @IBOutlet weak var btnPrice: UIButton!
    ///Outlet for detail button which is an arrow towards right direction on click of which opens OrderDetailVC
    @IBOutlet weak var btnDetail: UIButton!
    ///Outlet for order no. label which displays order no. concatenated with $ sign
    @IBOutlet weak var lblNo: UILabel!
    
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
