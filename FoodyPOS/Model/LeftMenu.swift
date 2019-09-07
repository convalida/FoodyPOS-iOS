//
//  LeftMenu.swift
//  FoodyPOS
//
//  Created by rajat on 29/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//
//  This file defines all objects which are used on Left Drawer menu

import Foundation

///Structure for view of Left menu.
struct LeftMenu {
    
    ///Used in LeftMenuVC. Variable to store array of icon and title of left menu for upper section. Used to show Dashboard, Orders, Customer details and Reports
    static let MainData = [        
        Main(image: #imageLiteral(resourceName: "home"), title: "Dashboard"),
        Main(image: #imageLiteral(resourceName: "orders"), title: "Orders"),
        Main(image: #imageLiteral(resourceName: "icon1-3"), title: "Customer Details"),
        Main(image: #imageLiteral(resourceName: "icon1-5"), title: "Reports")
    ]
    
    
    
    ///Used in LeftMenuVC. Variable to store array of icon and title of left menu for lower section. Used to show Employee, Change Password and Logout
    static let ProfileData = [
        Profile(image: #imageLiteral(resourceName: "icon1-6"), title: "Employee"),
        Profile(image: #imageLiteral(resourceName: "icon1-7"), title: "Change Password"),
        Profile(image: #imageLiteral(resourceName: "icon1-8"), title: "Logout")
    ]
    
    ///Structure for CellIdentifier which identifies type of cell is header cell or menu cell used in LeftMenuVC
    struct CellIdentifier {
        ///Identifier for header cell
        static let headerCell = "headerCell"
        
        ///Identifier for menu cell
        static let menuCell = "menuCell"
    }
    
    ///Structure upper section for Left menu.
    struct  Main {
        ///Variable for image view (icon) for various menu items in 0th section.
        let image:UIImage
        ///Variable for title for various menu items in 0th section.
        let title:String
    }
    
    
      ///Structure Profile section for Left menu
    struct Profile {
        ///Variable for image view (icon) for various menu items in 1st section.
        let image:UIImage
        ///Variable for title for various menu items in 1st section.
        let title:String
    }
    
}



