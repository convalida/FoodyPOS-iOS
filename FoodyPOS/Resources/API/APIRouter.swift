//
//  ViewController.swift
//  Decodeble
//
//  Created by Subhash Sharma on 25/06/18.
//  Copyright © 2018 OctalSoftware. All rights reserved.
//

import Alamofire

enum APIRouter: URLRequestConvertible {
    
    case login([String:Any])
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
   case .login:
            return .post
        // Get
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
            // Post
        case .login:
            return "/App/Api.asmx/GetLogin"
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
            // Post
        case .login(let parameter):
            print(parameter)
            return parameter
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .login:
            return JSONEncoding.default
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try K.ProductionServer.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        urlRequest = try parameterEncoding.encode(urlRequest, with: parameters)
        return urlRequest
    }
}

