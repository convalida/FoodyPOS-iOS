//
//  ViewController.swift
//  FoodyPOS
//
//  Created by rajat on 26/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//
//  All API routes are defined in this file. This file act as a Router for all API requests

import Alamofire

///Handler for preparing the requests before sending it to server
enum APIRouter: URLRequestConvertible {
    
    
    ///Case if login web service is hit
    case login([String:Any])
    ///Case if readNotification web service is hit
    case readNotification([String:Any])
    ///Case if bestselleritems web service is hit
    case bestselleritems([String:Any])
    ///Case if sales web service is hit
    case sales([String:Any])
    ///Case if orderList web service is hit
    case orderList([String:Any])
    ///Case if customers web service is hit
    case customers([String:Any])
    ///Case if dashboard web service is hit
    case dashboard([String:Any])
    ///Case if report web service is hit
    case report([String:Any])
    ///Case if addEmployee web service is hit
    case addEmployee([String:Any])
    ///Case if changePassword web service is hit
    case changePassword([String:Any])
    ///Case if forgotPassword web service is hit
    case forgotPassword([String:Any])
    ///Case if employee web service is hit
    case employee([String:Any])
    ///Case if updateEmployee web service is hit
    case updateEmployee([String:Any])
    ///Case if orderSearch web service is hit
    case orderSearch([String:Any])
    ///Case if resetPasword web service is hit
    case resetPasword([String:Any])
    ///Case if customerDetails web service is hit
    case customerDetails([String:Any])
    ///Case if getAllBestSeller web service is hit
    case getAllBestSeller([String:Any])
    ///Case if logout web service is hit
    case logout([String:Any])
    
    // MARK: - HTTPMethod
    /**
 Defines the HTTP method of request of login, readNotification, bestselleritems, sales, orderlist, customers, dashboard, report, addEmployee, changePassword, forgotPassword, employee, updateEmployee, orderSearch, resetPassword, customerDetails, getAllBestseller, logout is get request.
 */
    private var method: HTTPMethod {
        switch self {
   case .login,.readNotification,.bestselleritems,.sales,.orderList,.customers,.dashboard,.report,.addEmployee,.changePassword,.forgotPassword,.employee,.updateEmployee,.orderSearch,.resetPasword,.customerDetails, .getAllBestSeller, .logout:
            return .get
        }
    }
    
    ///Base path to be appneded for making web service url
    private var basePath:String {
        return "/App/Api.asmx"
    }
    
    // MARK: - Path
     ///Append base path with specific web service name
    private var path: String {
        switch self {
            // Post
        ///If login web service is hit, append base path to /LoginByApp string
        case .login:
            return basePath + "/LoginByApp"
        ///If read notification web service is hit, append base path to /ReadNotification string
        case .readNotification:
            return basePath + "/ReadNotificationByUser"
             ///If bestseller web service is hit, append base path to /bestselleritems string
        case .bestselleritems:
            return basePath + "/bestselleritems"
             ///If sales web service is hit, append base path to /sales string
        case .sales:
            return basePath + "/sales"
             ///If orderlist web service is hit, append base path to /Orderlist string
        case .orderList:
            return basePath + "/Orderlist"
             ///If orderSearch web service is hit, append base path to /Orderlist string
        case .orderSearch:
            return basePath + "/Orderlist"
             ///If customer web service is hit, append base path to /customer string
        case .customers:
            return basePath + "/customer"
             ///If dashboard web service is hit, append base path to /dashboard string
        case .dashboard:
            return basePath + "/dashboard"
             ///If reports web service is hit, append base path to /getreport string
        case .report:
            return basePath + "/getreport"
             ///If add employee web service is hit, append base path to /AddEmployee string
        case .addEmployee:
            return basePath + "/AddEmployee"
             ///If change password web service is hit, append base path to /ChangePaaword string
        case .changePassword:
            return basePath + "/ChangePaaword"
        ///If forgot password web service is hit, append base path to /ForgotPassword string
        case .forgotPassword:
            return basePath + "/ForgotPassword"
            ///If employee web service is hit, append base path to /ViewEmployee string
        case .employee:
            return basePath + "/ViewEmployee"
            ///If update employee web service is hit, append base path to /UpdateEmployee string
        case .updateEmployee:
            return basePath + "/UpdateEmployee"
            ///If reset password web service is hit, append base path to /OTP string
        case .resetPasword:
            return basePath + "/OTP"
            ///If customer details web service is hit, append base path to /CustomerDetails string
        case .customerDetails:
            return basePath + "/CustomerDetails"
            ///If get all bestseller  web service is hit, append base path to /GetAllBestslelleritems string
        case .getAllBestSeller:
            return basePath + "/GetAllBestselleritems"
            ///If logout web service is hit, append base path to /LogoutByApp string
        case .logout:
            return basePath + "/LogoutByApp"
        }
    }
    
    // MARK: - Parameters
    ///Parameters to be passed while hittng a particular web service
    private var parameters: Parameters? {
        switch self {
            // Post
         
    ///If login web service is hit, pass corresponding parameters specified in LoginVC and GLobal.swift
        case .login(let parameter):
            print(parameter)
            return parameter
        
        /**
     If read notification web service is hit, pass corresponding parameters specified in Global.swift
 */
        case .readNotification(let parameter):
            print(parameter)
            return parameter
    
      
            /**
             If bestsller items web service is hit, pass corresponding parameters specified in BestslellerVC
             */
        case .bestselleritems(let parameter):
            print(parameter)
            return parameter
         
            /**
                 If sales web service is hit, pass corresponding parameters specified in TopSaleVC and SalesSellAllVC
             */
        case .sales(let parameter):
            print(parameter)
            return parameter
          
            /**
             If orderlist web service is hit, pass corresponding parameters specified in OrderListVC
             */
        case .orderList(let parameter):
            print(parameter)
            return parameter
            
            /**
              If order search web service is hit, pass corresponding parameters specified in OrderListVC and OrderDetailVC
             */
        case .orderSearch(let parameter):
            print(parameter)
            return parameter
           
            /**
             If customers web service is hit, pass corresponsding parameters specified in SalesSellAllVC
             */
        case .customers(let parameter):
            print(parameter)
            return parameter
            
             /**
             If dashboard web service is hit, pass corresponsding parameters specified in DashboardVC
             */
        case .dashboard(let parameter):
            print(parameter)
            return parameter
            
            /**
             If reports web service is hit, pass corresponsding parameters specified in SalesReportVC
             */
        case .report(let parameter):
            print(parameter)
            return parameter
            
            /**
             If add employee web service is hit, pass corresponding parameters specified in SignUpVC
             */
        case .addEmployee(let parameter):
            print(parameter)
            return parameter
            
            /**
            If change password web service is hit, pass corresponding parameters specified in ChangePasswordVC
             */
        case .changePassword(let parameter):
            print(parameter)
            return parameter
          
            /**
             If forgot password web service is hit, pass corresponding parameters specified in ForgotPasswordVC and OtpVC
             */
        case .forgotPassword(let parameter):
            print(parameter)
            return parameter
           
            /**
             If employee web service is hit, pass corresponding parameters specified in EmployeeDetailVC
             */
        case .employee(let parameter):
            print(parameter)
            return parameter
            
            /**
             If update employee web service is hit, pass corresponding parameters specified in EditEmployeeVC
             */
        case .updateEmployee(let parameter):
            print(parameter)
            return parameter
           
            /**
             If reset password web service is hit, pass corresponding parameters specified in OtpVC and ResetPasswordVC
             */
        case .resetPasword(let parameter):
            print(parameter)
            return parameter
            
            /**
             If customer details web service is hit, pass corresponding parameters specified in CustomerDetailVC
             */
        case .customerDetails(let parameter):
            print(parameter)
            return parameter
            
            /**
             If get all bestseller web service is hit, pass corresponding parameters specified in AllBestSellerVC
             */
        case .getAllBestSeller(let parameter):
            print(parameter)
            return parameter
            
            /**
             If logout web service is hit, pass corresponding parameters specified in DashboardVC and LeftMenuVC
             */
        case .logout(let parameter):
            print(parameter)
            return parameter
        }
    }
    
    ///This defines the type of encoding for parameteres according to request method type.
    var parameterEncoding: ParameterEncoding {
        switch method {
             ///If request is of type get, return URLEncoding instance with a .queryString destination
        case .get:
            return URLEncoding.queryString
            ///If request is of type post, return JSONEncoding instance with a .default destination. 
        case .post:
            return JSONEncoding.default
           
             ///If request is of type post, return JSONEncoding instance with a .default destination.
        default:
            return JSONEncoding.default
        }
    }
    
    // MARK: - URLRequestConvertible
        /**
 Create url request to call web service globally.
     Set requested url is base url defined in Production server structure, append base path with web service name with request type and parameters. Set timeout as 60 sec. Set request as HTTP method corresponding raw type, encode the url and return the url
 */
    /// Create url request globally
    func asURLRequest() throws -> URLRequest {
        var url = try K.ProductionServer.baseURL.asURL()
       //  let url = try K.ProductionServer.baseURL_2.asURL()
        print(path)
       /** if path == "/App/Api.asmx/ReadNotificationByUser" || path=="/App/Api.asmx/ReadNotificationByUser" || path=="/App/Api.asmx/ReadNotificationByUser" {
            url = try K.ProductionServer.baseURL_2.asURL()
        }**/
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.timeoutInterval = 90.0 //Set request timeout
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
       // urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
       // urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        urlRequest = try parameterEncoding.encode(urlRequest, with: parameters)
        return urlRequest
    }
}

