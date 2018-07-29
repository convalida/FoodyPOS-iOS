//
//  TopSaleCell.swift
//  FoodyPOS
//
//  Created by rajat on 29/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

class TopSaleCell: UITableViewCell {

    @IBOutlet weak var lblLetter: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnPhone: UIButton!
    @IBOutlet weak var lblOrder: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnSeeAll: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
