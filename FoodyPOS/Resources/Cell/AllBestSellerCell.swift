//
//  AllBestSellerCell.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 22/11/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

/**
This class is used for creating view inside cell in AllBestSellerVC.
*/
class AllBestSellerCell: UITableViewCell {

    ///Outlet for title in header cell used for displaying week, month or year depending on weekly, monthly or yearly bestseller more is shown  
    @IBOutlet weak var lblHeaderTitle: UILabel!
    ///Outlet for image of arrow in header cell which changes its rotation angle depending on status of header cell is opened or closed.
     @IBOutlet weak var imgHeader: UIImageView!
     ///Outlet for item name in item cell which displays name of item
    @IBOutlet weak var lblItemName: UILabel!
    ///Outlet for item count in item cell which displays count of item
    @IBOutlet weak var lblItemCount: UILabel!
    
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
