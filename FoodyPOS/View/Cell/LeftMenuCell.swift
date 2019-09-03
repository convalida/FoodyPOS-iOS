//
//  LeftMenuCell.swift
//  FoodyPOS
//
//  Created by rajat on 29/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

/**
This class is used for creating view inside cell in LeftMenuVC.
*/
class LeftMenuCell: UITableViewCell {

    ///Outlet for header text in left menu which displays Profile in section 1
    @IBOutlet weak var lblHeader: UILabel!
    ///Outlet for icons in left menu, set in LeftMenu.swift
    @IBOutlet weak var imgIcon: UIImageView!
    ///Outlet for title/items in LeftMenu, set in LeftMenu.swift
    @IBOutlet weak var lblTitle: UILabel!
    ///Outlet for border which is hidden for section 0 and visible for section 1. Minakshi ji yes the border is above Profile text
    @IBOutlet weak var viewBorder: UIView!
    
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
