//
//  APIRouter.swift
//  BeerApp
//
//  Created by Leandro Paiva Andrade on 5/4/18.
//  Copyright © 2018 Leandro. All rights reserved.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
  
    case getBeersList()
    case getBeerWithName(name: String)
    
    func getPathString() -> String {
        // Divided in two request just for demo purpose and to understand more the VIPER Arch
        switch self {
        case .getBeersList():
            return ("\(APIConstants.kBeerPath)")
        case .getBeerWithName(let name):
            if name.isEmpty {
                return ("\(APIConstants.kBeerPath)")
            } else {
                return ("\(APIConstants.kBeerPath)\(APIConstants.kBeerQuery)\(name)")
            }
            
        }
    }
    
    func getMethod() -> HTTPMethod {
        switch self {
        case .getBeersList(),
             .getBeerWithName(_):
            return .get
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        let urlString = APIConstants.baseApiUrl + getPathString()
        let url = try urlString.asURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = getMethod().rawValue
        
        return try Alamofire.URLEncoding.default.encode(urlRequest, with: nil)
    }

}
