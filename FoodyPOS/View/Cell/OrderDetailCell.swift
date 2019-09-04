//
//  OrderDetailCell.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 19/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

/**
This class is used for creating view inside cell in OrderDetailVC.
*/
class OrderDetailCell: UITableViewCell {

    ///Outlet for item name text field
    @IBOutlet weak var lblSubitem: UILabel!
    ///Outlet for modifier text field
    @IBOutlet weak var lblModifier: UILabel!
    //Outlet for add on text field
    @IBOutlet weak var lblAddOn: UILabel!
    ///Outlet for instruction text field
    @IBOutlet weak var lblInstruction: UILabel!
    ///Outlet for price text field
    @IBOutlet weak var lblPrice: UILabel!
    ///Outlet for add on price text field
    @IBOutlet weak var lblAddOnPrice: UILabel!
    ///Outlet for total price text field
    @IBOutlet weak var lblTotal: UILabel!
    ///Stack view outlet for showing item name of order
    @IBOutlet weak var stackSubitem: UIStackView!
    ///Stack view outlet for showing modifier
    @IBOutlet weak var stackModifier: UIStackView!
    ///Stack view outlet for showing add on
    @IBOutlet weak var stackAddOn: UIStackView!
    ///Stack view outlet for showing instruction
    @IBOutlet weak var stackInstruction: UIStackView!
    ///Stack view outlet for showing price
    @IBOutlet weak var stackPrice: UIStackView!
    ///Stack view outlet for showing add on price
    @IBOutlet weak var stackAddOnPrice: UIStackView!
    ///Stack view outlet for showing total modifier
    @IBOutlet weak var stackTotal: UIStackView!
    
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
