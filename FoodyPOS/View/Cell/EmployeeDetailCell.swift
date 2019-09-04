//
//  EmployeeDetailCell.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 05/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

/**
This class is used for creating view inside cell in EmployeeDetailVC.
*/
class EmployeeDetailCell: UITableViewCell {
    ///This is for showing placeholder image of an user
    @IBOutlet weak var imgUser: UIImageView!
    ///Outlet for use name of employee
    @IBOutlet weak var lblName: UILabel!
    ///Outlet for email id of employee
    @IBOutlet weak var lblEmail: UILabel!
    ///Outlet for role of employee
    @IBOutlet weak var lblRole: UILabel!
    ///Outlet for active status of cell which displays "Active: Yes" if employee is active and "Active: No" if employee is not active
    @IBOutlet weak var lblStatus: UILabel!
    ///Outlet for edit button on click of which it opens EditEmployeeVC
    @IBOutlet weak var btnEdit: UIButton!
    
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
