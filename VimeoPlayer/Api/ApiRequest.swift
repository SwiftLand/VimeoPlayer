//
//  ApiRequest.swift
//  VimeoPlayer
//
//  Created by Ali on 2/17/23.
//

import Foundation

enum HTTPMethod:String{
    case get = "GET"
    case post = "POST"
}

enum ApiRequest{
    case search(searchRequest:SearchRequest)
    case videoConfig(id:String)
    
 
    private static var httpHeaderFields:[String:String] = [
        "Authorization" : "bearer \(Constants.Vimeo.public_token)"
    ]
  
    
    static func getRequest(for type:ApiRequest)->URLRequest{
        
        switch type {
        case search(let searchRequest):
            var request = URLRequest(url:ApiRoute.getUrl(for: .videos(params: searchRequest.asURLQueryItems)))
            request.httpMethod = HTTPMethod.get.rawValue
            for header in httpHeaderFields{
                request.addValue(header.value, forHTTPHeaderField: header.key)
            }
            return request
        case videoConfig(let id):
            var request = URLRequest(url: ApiRoute.getUrl(for: .config(id: id)))
            request.httpMethod = HTTPMethod.get.rawValue
            return request
        }
    }
}
