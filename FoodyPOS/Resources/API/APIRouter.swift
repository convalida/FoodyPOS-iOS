//
//  ViewController.swift
//  FoodyPOS
//
//  Created by rajat on 26/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//
//  All API routes are defined in this file. This file act as a Router for all API requests

import Alamofire

enum APIRouter: URLRequestConvertible {
    
    
    case login([String:Any])
    case readNotification([String:Any])
    case bestselleritems([String:Any])
    case sales([String:Any])
    case orderList([String:Any])
    case customers([String:Any])
    case dashboard([String:Any])
    case report([String:Any])
    case addEmployee([String:Any])
    case changePassword([String:Any])
    case forgotPassword([String:Any])
    case employee([String:Any])
    case updateEmployee([String:Any])
    case orderSearch([String:Any])
    case resetPasword([String:Any])
    case customerDetails([String:Any])
    case getAllBestSeller([String:Any])
    case logout([String:Any])
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
   case .login,.readNotification,.bestselleritems,.sales,.orderList,.customers,.dashboard,.report,.addEmployee,.changePassword,.forgotPassword,.employee,.updateEmployee,.orderSearch,.resetPasword,.customerDetails, .getAllBestSeller, .logout:
            return .get
        }
    }
    
    private var basePath:String {
        return "/App/Api.asmx"
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
            // Post
        case .login:
            return basePath + "/LoginByApp"
        case .readNotification:
            return basePath + "/ReadNotificationByUser"
        case .bestselleritems:
            return basePath + "/bestselleritems"
        case .sales:
            return basePath + "/sales"
        case .orderList:
            return basePath + "/Orderlist"
        case .orderSearch:
            return basePath + "/Orderlist"
        case .customers:
            return basePath + "/customer"
        case .dashboard:
            return basePath + "/dashboard"
        case .report:
            return basePath + "/getreport"
        case .addEmployee:
            return basePath + "/AddEmployee"
        case .changePassword:
            return basePath + "/ChangePaaword"
        case .forgotPassword:
            return basePath + "/ForgotPassword"
        case .employee:
            return basePath + "/ViewEmployee"
        case .updateEmployee:
            return basePath + "/UpdateEmployee"
        case .resetPasword:
            return basePath + "/OTP"
        case .customerDetails:
            return basePath + "/CustomerDetails"
        case .getAllBestSeller:
            return basePath + "/GetAllBestselleritems"
        case .logout:
            return basePath + "/LogoutByApp"
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
            // Post
        case .login(let parameter):
            print(parameter)
            return parameter
            
        case .readNotification(let parameter):
            print(parameter)
            return parameter
            
        case .bestselleritems(let parameter):
            print(parameter)
            return parameter
            
        case .sales(let parameter):
            print(parameter)
            return parameter
            
        case .orderList(let parameter):
            print(parameter)
            return parameter
            
        case .orderSearch(let parameter):
            print(parameter)
            return parameter
            
        case .customers(let parameter):
            print(parameter)
            return parameter

        case .dashboard(let parameter):
            print(parameter)
            return parameter
            
        case .report(let parameter):
            print(parameter)
            return parameter
            
        case .addEmployee(let parameter):
            print(parameter)
            return parameter
            
        case .changePassword(let parameter):
            print(parameter)
            return parameter
            
        case .forgotPassword(let parameter):
            print(parameter)
            return parameter
            
        case .employee(let parameter):
            print(parameter)
            return parameter
            
        case .updateEmployee(let parameter):
            print(parameter)
            return parameter
            
        case .resetPasword(let parameter):
            print(parameter)
            return parameter
            
        case .customerDetails(let parameter):
            print(parameter)
            return parameter
            
        case .getAllBestSeller(let parameter):
            print(parameter)
            return parameter
            
        case .logout(let parameter):
            print(parameter)
            return parameter
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.queryString
        case .post:
            return JSONEncoding.default
            
        default:
            return JSONEncoding.default
        }
    }
    
    // MARK: - URLRequestConvertible
    /// Create url request Globally
    func asURLRequest() throws -> URLRequest {
       // var url = try K.ProductionServer.baseURL.asURL()
         let url = try K.ProductionServer.baseURL_2.asURL()
        print(path)
       /** if path == "/App/Api.asmx/ReadNotificationByUser" || path=="/App/Api.asmx/ReadNotificationByUser" || path=="/App/Api.asmx/ReadNotificationByUser" {
            url = try K.ProductionServer.baseURL_2.asURL()
        }**/
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.timeoutInterval = 60.0
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
       // urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
       // urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        urlRequest = try parameterEncoding.encode(urlRequest, with: parameters)
        return urlRequest
    }
}

