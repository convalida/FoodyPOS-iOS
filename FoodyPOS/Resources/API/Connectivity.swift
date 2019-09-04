//
//  Connectivity.swift
//  FoodyPOS
//
//  Created by rajat on 26/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//


import Foundation
import Alamofire

///Class to check if internet is connected.
class Connectivity {
    
    ///Message which is displayed when internet is not connected.
    static let msgNoNetwork = "The Internet connection appears to be offline"
    
    ///Check if device is connected to internet which uses NetworkReachabilityManager() which is pre defined class
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
}
