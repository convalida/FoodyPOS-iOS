//
//  ViewController.swift
//  FoodyPOS
//
//  Created by rajat on 26/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//
//  All constants which are used in the application is defined in this file

import Foundation

///Create a struct to be used throughout the application for various keys and settings
struct K {
    /**
     Structure for configuration of app to set the base demo and live url.
     */
    struct ProductionServer {
        ///Set base url for all web services (live url)
        static let baseURL = "http://business.foodypos.com"
        ///Set base url for all web services (demo url)
        static let baseURL_2 = "http://staging.foodypos.com"
    }
}

///All header fields which are to be sent in every request
enum HTTPHeaderField: String {
    ///Authentication header key for web service
    case authentication = "Authorization"
    ///Request content type header key for web service
    case contentType = "Content-Type"
    ///Accept type header key for web service
    case acceptType = "Accept"
    ///Accept-Encoding header key for web service
    case acceptEncoding = "Accept-Encoding"
}

///API request content type definations.
enum ContentType: String {
    ///Content-type definations for web services
    case json = "application/json"
}
