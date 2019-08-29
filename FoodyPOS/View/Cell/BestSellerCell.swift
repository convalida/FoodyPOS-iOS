//
//  BestSellerCell.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 04/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

/**
This class is used for creating view inside cell in BestSellerVC.
*/
class BestSellerCell: UITableViewCell {

    ///Outlet for title which displays weekly bestseller items, monthly bestseller items and yearly bestseller items for each corresponding section
    @IBOutlet weak var lblTitle: UILabel!
    ///Outlet for item 1 name
    @IBOutlet weak var lblItem1: UILabel!
    ///Outlet for item 2 name
    @IBOutlet weak var lblItem2: UILabel!
    ///Outlet for item 3 name
    @IBOutlet weak var lblItem3: UILabel!
    ///Outlet for count of item 1 
    @IBOutlet weak var lblValue1: UILabel!
    ///Outlet for count of item 2
    @IBOutlet weak var lblValue2: UILabel!
    ///Outlet for count of item 3
    @IBOutlet weak var lblValue3: UILabel!
    ///Outlet for See All button
    @IBOutlet weak var btnAll: UIButton!
    
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
