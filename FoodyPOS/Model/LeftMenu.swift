//
//  LeftMenu.swift
//  FoodyPOS
//
//  Created by rajat on 29/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//
//  This file defines all objects which are used on Left Drawer menu

import Foundation

struct LeftMenu {
    
    static let MainData = [        
        Main(image: #imageLiteral(resourceName: "home"), title: "Dashboard"),
        Main(image: #imageLiteral(resourceName: "orders"), title: "Orders"),
        Main(image: #imageLiteral(resourceName: "icon1-3"), title: "Customer Details"),
        Main(image: #imageLiteral(resourceName: "icon1-5"), title: "Reports")
    ]
    
    static let ProfileData = [
        Profile(image: #imageLiteral(resourceName: "icon1-6"), title: "Employee"),
        Profile(image: #imageLiteral(resourceName: "icon1-7"), title: "Change Password"),
        Profile(image: #imageLiteral(resourceName: "icon1-8"), title: "Logout")
    ]
    
    struct CellIdentifier {
        static let headerCell = "headerCell"
        static let menuCell = "menuCell"
    }
    
    struct  Main {
        let image:UIImage
        let title:String
    }
    
    struct Profile {
        let image:UIImage
        let title:String
    }
}
