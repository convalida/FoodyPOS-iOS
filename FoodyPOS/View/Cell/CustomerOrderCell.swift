//
//  CustomerOrderCell.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 30/11/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

class CustomerOrderCell: UITableViewCell {

    @IBOutlet weak var btnTime: UIButton!
    @IBOutlet weak var btnPrice: UIButton!
    @IBOutlet weak var btnDetail: UIButton!
    @IBOutlet weak var lblNo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
