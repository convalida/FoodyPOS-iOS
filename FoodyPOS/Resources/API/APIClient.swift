//
//  ViewController.swift
//  Decodeble
//
//  Created by Subhash Sharma on 25/06/18.
//  Copyright © 2018 OctalSoftware. All rights reserved.
//

import Alamofire
import CodableAlamofire

class APIClient {
    
    @discardableResult
    private static func performRequest<T:Decodable>(route:APIRouter, decoder: JSONDecoder, completion:@escaping (Result<T>)->Void) -> DataRequest {
        print(route.urlRequest!)
        
        Global.showHud()
        return Alamofire.request(route).responseDecodableObject(decoder: decoder, completionHandler: { (response:DataResponse<T>) in
            Global.hideHud()
            print("Result:\(String(describing: response.result.value))")
            completion(response.result)
        })
    }
    
    private static var jsonDecoder:JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .secondsSince1970
        return jsonDecoder
    }
    
    public static func login(paramters:[String:Any], completion:@escaping (Result<User>) -> Void) {
        performRequest(route: APIRouter.login(paramters), decoder: jsonDecoder, completion: completion)
    }
    
}

