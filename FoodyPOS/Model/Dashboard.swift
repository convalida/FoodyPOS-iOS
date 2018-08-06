//
//  Dashboard.swift
//  FoodyPOS
//
//  Created by rajat on 28/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import Foundation

struct Dashboard {
    struct Data {
        let title:String
        let subtitle:String
        let icon:UIImage
    }
    
    static let titleArray = [Data(title: "Total Sale", subtitle: "$22434.445", icon: #imageLiteral(resourceName: "icon1")),
                             Data(title: "Weekly Sale", subtitle: "$340.42", icon: #imageLiteral(resourceName: "icon2")),
                             Data(title: "Total Orders", subtitle: "867", icon: #imageLiteral(resourceName: "icon3")),
                             Data(title: "Weekly Orders", subtitle: "21", icon: #imageLiteral(resourceName: "icon4")),
                             Data(title: "Total Customers", subtitle: "814", icon: #imageLiteral(resourceName: "icon5")),
                             Data(title: "Weekly Customers", subtitle: "95", icon: #imageLiteral(resourceName: "icon6"))]
    struct CellIdentifier {
        static let dashboardCell = "dashboardCell"
    }
}
