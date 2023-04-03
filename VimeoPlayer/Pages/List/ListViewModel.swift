//
//  ListViewModel.swift
//  VimeoPlayer
//
//  Created by Ali on 3/8/23.
//

import Foundation
import Combine

final class ListViewModel:ObservableObject,NavigableProtocol{

    var navigate: PassthroughSubject<FlowAction, Never> = .init()
    
    @Published var data:[VimeoResponse.Data] = []
    @Published var status: LoadStatus?
    
    private var cancellable = Set<AnyCancellable>()
  
    func search(for request:SearchRequest){
       
        if request.page == 1 {
            data = []
        }
        
        status = .loading
        
        ApiRepository().search(for: request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                [weak self] result in
                switch result {
                case .failure(let error):
                    self?.status = .error(error: error)
                case .finished:break
                }
            }, receiveValue: {[weak self] value in
                self?.status = .fetched
                self?.data.append(contentsOf: value.data)
            }).store(in: &cancellable)
    }
    
    func selectItem(with data:VimeoResponse.Data){
        navigate.send(.showDetail(detail: data))
    }
}
