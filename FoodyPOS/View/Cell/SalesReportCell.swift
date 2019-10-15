//
//  SalesReportCell.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 04/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

/**
This class is used for creating view inside cell in SalesReportVC.
*/
class SalesReportCell: UITableViewCell {

    ///Outlet for day/week/month text depending upon daily/weekly/monthly section is active
    @IBOutlet weak var lblDay: UILabel!
    ///Outlet for no. of orders text on a day/week/month
    @IBOutlet weak var lblOrder: UILabel!
    ///Outlet for price amount text on a day/week/month
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
