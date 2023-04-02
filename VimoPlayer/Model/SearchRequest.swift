//
//  SearchRequest.swift
//  VimoPlayer
//
//  Created by Ali on 2/14/23.
//

import Foundation

struct SearchRequest {
    var query:String
    var page:Int
    var per_page:Int
    
    init(query: String,page:Int = 1,per_page:Int = 10) {
        self.query = query
        self.page = page
        self.per_page = per_page
    }

    var asURLQueryItems:[URLQueryItem]{
        [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: String(per_page))
        ]
    }
}
