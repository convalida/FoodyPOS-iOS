//
//  OrderListCell.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 02/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

/**
This class is used for creating view inside cell in OrderListVC.
*/
class OrderListCell: UITableViewCell {
    ///Outlet for header date which displays date in 0th row of cell. Rajat ji please check this. Will update at other places accordingly.
    @IBOutlet weak var lblHeaderDate: UILabel!
    ///Outlet for no. of orders on a date, displayed in 0th row of cell
    @IBOutlet var lblHeaderOrder: UILabel!
    ///Outlet for total amount of sale on a date, displayed in 0th row of cell
    @IBOutlet weak var lblHeaderPrice: UILabel!
    ///Outlet for order no., displayed in row other than 0th row of cell. Rajat ji please check this. Will update at other places accordingly.
    @IBOutlet weak var lblListNum: UILabel!
    ///Outlet for time button, displayed in row other than 0th row of cell. Rajat ji please check if it is button, as there is no click listener.
    @IBOutlet weak var btnListTIme: UIButton!
    ///Outlet for price text concatenated with $ sign, displayed in row other than 0th row of cell.
    @IBOutlet weak var lblListPrice: UILabel!
    ///Outlet for arrow image whose direction is upward in case header is opened and downward if it is closed and is displayed  in 0th row of cell. Rajat ji please check this
    @IBOutlet weak var imgHeader: UIImageView!
    
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
