//
//  DashboardCell.swift
//  FoodyPOS
//
//  Created by rajat on 28/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

/**
This class is used for creating view inside cell in DashboardVC.
*/
class DashboardCell: UITableViewCell {

    ///This is used for all cells in the dashboard
    @IBOutlet weak var viewColor: UIView!
    ///Outlet for title which are keys of label values of response in dashboard like Total Sale, Total Orders, etc. set in manageData in DashboardVC
    @IBOutlet weak var lblTitle: UILabel!
    ///Outlet for subtitle in DashboardVC are values of label values of response in dashboard like values of Total Sale, Total Orders, etc. set in manageData in DashboardVC
    @IBOutlet weak var lblValue: UILabel!
    ///Outlet for icon in cell set in manageData in DashboardVC
    @IBOutlet weak var imgIcon: UIImageView!
    
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
