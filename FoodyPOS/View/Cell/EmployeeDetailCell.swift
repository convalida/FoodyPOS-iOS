//
//  EmployeeDetailCell.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 05/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

class EmployeeDetailCell: UITableViewCell {
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblRole: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
