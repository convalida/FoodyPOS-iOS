//
//  ViewController.swift
//  FoodyPOS
//
//  Created by rajat on 26/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//
//  All constants which are used in the application is defined in this file

import Foundation

struct K {
    struct ProductionServer {
        static let baseURL = "http://business.foodypos.com"
        static let baseURL_2 = "http://demo.metropolisgrill.com"
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}
