//
//  OrderDetailCell.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 19/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

class OrderDetailCell: UITableViewCell {

    @IBOutlet weak var lblSubitem: UILabel!
    @IBOutlet weak var lblModifier: UILabel!
    @IBOutlet weak var lblAddOn: UILabel!
    @IBOutlet weak var lblInstruction: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblAddOnPrice: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var stackSubitem: UIStackView!
    @IBOutlet weak var stackModifier: UIStackView!
    @IBOutlet weak var stackAddOn: UIStackView!
    @IBOutlet weak var stackInstruction: UIStackView!
    @IBOutlet weak var stackPrice: UIStackView!
    @IBOutlet weak var stackAddOnPrice: UIStackView!
    @IBOutlet weak var stackTotal: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
