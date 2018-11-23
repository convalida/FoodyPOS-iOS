//
//  BestSellerCell.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 04/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

class BestSellerCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblItem1: UILabel!
    @IBOutlet weak var lblItem2: UILabel!
    @IBOutlet weak var lblItem3: UILabel!
    @IBOutlet weak var lblValue1: UILabel!
    @IBOutlet weak var lblValue2: UILabel!
    @IBOutlet weak var lblValue3: UILabel!
    @IBOutlet weak var btnAll: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
