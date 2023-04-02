//
//  ApiRepository.swift
//  VimoPlayer
//
//  Created by Ali on 2/14/23.
//

import Foundation
import RxSwift
import RxCocoa

protocol ApiRepositoryProtocol{
    var session:URLSession{get set}
    func search(for request:SearchRequest)->Observable<VimoResponse>
    func getVideoconfig(for id:String)->Observable<VimoVideoConfig>
}

struct ApiRepository:ApiRepositoryProtocol{
    
    var session:URLSession = URLSession.shared

    public func search(for request:SearchRequest)->Observable<VimoResponse>{
        let request = ApiRequest.getRequest(for: .search(searchRequest: request))
        return dataRequest(request:request)
    }
    
    public func getVideoconfig(for id:String)->Observable<VimoVideoConfig>{
        let request =  ApiRequest.getRequest(for: .videoConfig(id: id))
        return dataRequest(request:request)
    }
    
    
    private func dataRequest<T:Decodable>(request:URLRequest)->Observable<T> {
        return session.rx.data(request: request)
            .map{ data in
                do{
//                print(data.prettyPrintedJSONString)
                  return try JSONDecoder().decode(T.self, from: data)
                }catch{
                    throw RxCocoaURLError.deserializationError(error: error)
               }
        }
    }
}
