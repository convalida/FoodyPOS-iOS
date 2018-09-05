//
//  OrderListCell.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 02/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

class OrderListCell: UITableViewCell {
    @IBOutlet weak var lblHeaderDate: UILabel!
    @IBOutlet var lblHeaderOrder: UILabel!
    @IBOutlet weak var lblHeaderPrice: UILabel!
    @IBOutlet weak var lblListNum: UILabel!
    @IBOutlet weak var btnListTIme: UIButton!
    @IBOutlet weak var lblListPrice: UILabel!
    @IBOutlet weak var imgHeader: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
