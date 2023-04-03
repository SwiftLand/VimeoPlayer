//
//  ApiRoute.swift
//  VimeoPlayer
//
//  Created by Ali on 2/16/23.
//

import Foundation

enum ApiRoute{
    
    case videos(params:[URLQueryItem])
    case config(id:String)
    
    static func getUrl(for route:ApiRoute)->URL{
        
        switch route {
        case .videos(let params):
            
            let rawURL = URL(string: Constants.Vimeo.Vimeo_base_url + "videos")!
            var urlComps = URLComponents(url:rawURL, resolvingAgainstBaseURL: false)!
            urlComps.queryItems = params
            return urlComps.url!
            
        case .config(let id):
            return URL(string:Constants.Vimeo.Vimeo_video_config_url.replacingOccurrences(of: "{id}", with: id))!
        }
    }
}
