//
//  AllBestSellerCell.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 22/11/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import UIKit

class AllBestSellerCell: UITableViewCell {

    @IBOutlet weak var lblHeaderTitle: UILabel!
     @IBOutlet weak var imgHeader: UIImageView!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblItemCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
