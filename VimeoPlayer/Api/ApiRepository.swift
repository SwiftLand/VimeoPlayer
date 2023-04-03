//
//  ApiRepository.swift
//  VimeoPlayer
//
//  Created by Ali on 2/14/23.
//

import Foundation
import Combine


enum APIError: Error {
    case internalError(code:Int)
    case httpError(code:Int)
    case parseError
}

protocol ApiRepositoryProtocol{
    var session:URLSession{get set}
    func search(for request:SearchRequest)->AnyPublisher<VimeoResponse, APIError>
    func getVideoconfig(for id:String)->AnyPublisher<VimeoVideoConfig, APIError>
}

struct ApiRepository:ApiRepositoryProtocol{
    
    var session:URLSession = URLSession.shared
    
    
    public func search(for request:SearchRequest)-> AnyPublisher<VimeoResponse, APIError>{
        let request = ApiRequest.getRequest(for: .search(searchRequest: request))
        return dataRequest(request:request)
    }
    
    public func getVideoconfig(for id:String)-> AnyPublisher<VimeoVideoConfig, APIError>{
        let request =  ApiRequest.getRequest(for: .videoConfig(id: id))
        return dataRequest(request:request)
    }
    
    
    private func dataRequest<T:Decodable>(request:URLRequest)->AnyPublisher<T,APIError> {
        Deferred{ Future<T,APIError>{promise in
            session.dataTask(with: request){
                data,response,error in
                
                guard error == nil else {
                    promise(.failure(.internalError(code: (error! as NSError).code)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else{
                    promise(.failure(.parseError))
                    return
                }
                
                guard httpResponse.isOK else {
                    promise(.failure(.httpError(code: httpResponse.statusCode)))
                    return
                }
                
                guard let data = data,
                      let parsedData = try? JSONDecoder().decode(T.self, from: data)
                else {
                    promise(.failure(.parseError))
                    return
                }
                
                promise(.success(parsedData))
            }.resume()
        }
        }.subscribe(on: DispatchQueue.global(qos: .background))
            .eraseToAnyPublisher()
    }
}
