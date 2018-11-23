//
//  ViewController.swift
//  FoodyPOS
//
//  Created by rajat on 26/07/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//
//  This file acts as a centeral system for calling all APIs and parsing their data

import Alamofire
import CodableAlamofire

class APIClient {
    
    @discardableResult
    private static func performRequest<T:Decodable>(route:APIRouter, decoder: JSONDecoder, keyPath:String? = nil, completion:@escaping (Result<T>)->Void) -> DataRequest {
        print(route.urlRequest!)
       // Global.showHud()
        
        return Alamofire.request(route).responseDecodableObject(queue: nil, keyPath: keyPath, decoder: decoder, completionHandler: { (response:DataResponse<T>) in
          //  Global.hideHud()
            print("Result:\(String(describing: response.result.value))")
            completion(response.result)
        })
    }
    
    private static var jsonDecoder:JSONDecoder {
        let jsonDecoder = JSONDecoder()
        //jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .secondsSince1970
        return jsonDecoder
    }
    
    public static func login(paramters:[String:Any], completion:@escaping (Result<User>) -> Void) {
        performRequest(route: APIRouter.login(paramters), decoder: jsonDecoder, completion: completion)
    }
    
    public static func bestSellerItems(paramters:[String:Any], completion:@escaping (Result<BestSeller>) -> Void) {
        performRequest(route: APIRouter.bestselleritems(paramters), decoder: jsonDecoder, completion: completion)
    }
    
    public static func sales(paramters:[String:Any], completion:@escaping (Result<Sale>) -> Void) {
        performRequest(route: APIRouter.sales(paramters), decoder: jsonDecoder, completion: completion)
    }
    
    public static func customers(paramters:[String:Any], completion:@escaping (Result<Customers>) -> Void) {
        performRequest(route: APIRouter.customers(paramters), decoder: jsonDecoder, completion: completion)
    }

    public static func report(paramters:[String:Any], completion:@escaping (Result<Report>) -> Void) {
        performRequest(route: APIRouter.report(paramters), decoder: jsonDecoder, completion: completion)
    }
    
    public static func dashboard(paramters:[String:Any], completion:@escaping (Result<Dashboard1>) -> Void) {
        performRequest(route: APIRouter.dashboard(paramters), decoder: jsonDecoder, completion: completion)
    }
    
    public static func order(paramters:[String:Any], completion:@escaping (Result<Order>) -> Void) {
        performRequest(route: APIRouter.orderList(paramters), decoder: jsonDecoder, keyPath:"By_DateSelection" ,completion: completion)
    }
    
    public static func changePassword(paramters:[String:Any], completion:@escaping (Result<ChangePassword>) -> Void) {
        performRequest(route: APIRouter.changePassword(paramters), decoder: jsonDecoder, completion: completion)
    }
    
    public static func forgotPassword(paramters:[String:Any], completion:@escaping (Result<ForgotPassword>) -> Void) {
        performRequest(route: APIRouter.forgotPassword(paramters), decoder: jsonDecoder, completion: completion)
    }
    
    /// Call Employee list api and return Employee Object
    public static func employee(paramters:[String:Any], completion:@escaping (Result<Employee>) -> Void) {
        performRequest(route: APIRouter.employee(paramters), decoder: jsonDecoder, completion: completion)
    }
    
    public static func addEmployee(paramters:[String:Any], completion:@escaping (Result<AddEmployee>) -> Void) {
        performRequest(route: APIRouter.addEmployee(paramters), decoder: jsonDecoder, completion: completion)
    }
    
    public static func updateEmployee(paramters:[String:Any], completion:@escaping (Result<UpdateEmployee>) -> Void) {
        performRequest(route: APIRouter.updateEmployee(paramters), decoder: jsonDecoder, completion: completion)
    }
    
    public static func orderSearch(paramters:[String:Any], completion:@escaping (Result<OrderSearch>) -> Void) {
        performRequest(route: APIRouter.orderSearch(paramters), decoder: jsonDecoder, completion: completion)
    }
    
    public static func resetPassword(paramters:[String:Any], completion:@escaping (Result<ResetPassword>) -> Void) {
        performRequest(route: APIRouter.resetPasword(paramters), decoder: jsonDecoder, completion: completion)
    }
    
    public static func customerDetails(paramters:[String:Any], completion:@escaping (Result<CustomerDetail>) -> Void) {
        performRequest(route: APIRouter.customerDetails(paramters), decoder: jsonDecoder, completion: completion)
    }
    
    public static func getAllBestSeller(paramters:[String:Any], completion:@escaping (Result<AllBestSeller>) -> Void) {
        performRequest(route: APIRouter.getAllBestSeller(paramters), decoder: jsonDecoder, completion: completion)
    }
}

