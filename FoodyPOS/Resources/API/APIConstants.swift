//
//  ViewController.swift
//  Decodeble
//
//  Created by Subhash Sharma on 25/06/18.
//  Copyright © 2018 OctalSoftware. All rights reserved.
//

import Foundation

struct K {
    struct ProductionServer {
        static let baseURL = "http://business.foodypos.com"
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
