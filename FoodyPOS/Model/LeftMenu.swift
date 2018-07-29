//
//  LeftMenu.swift
//  FoodyPOS
//
//  Created by rajat on 29/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import Foundation

struct LeftMenu {
    
    static let MainData = [Main(image: "", title: "Dashboard"),Main(image: "", title: "Orders"),Main(image: "", title: "Customer Details"),Main(image: "", title: "Reports")]
    static let ProfileData = [Profile(image: "", title: "Employee"),Profile(image: "", title: "Change Password"),Profile(image: "", title: "Logout")]
    
    struct CellIdentifier {
        static let headerCell = "headerCell"
        static let menuCell = "menuCell"
    }
    
    struct  Main {
        let image:String
        let title:String
    }
    
    struct Profile {
        let image:String
        let title:String
    }
}
