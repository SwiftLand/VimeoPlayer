//
//  FlowViewModel.swift
//  VimeoPlayer
//
//  Created by Ali on 3/12/23.
//

import Foundation
import Combine

class FlowViewModel: ObservableObject {
    
    @Published var navigationPath: [Screen] = []
    private var subscription = Set<AnyCancellable>()
    
    func getListViewModel() -> ListViewModel {
        let vm = ListViewModel()
        dispatch(vm)
        return vm
    }
    
    func makeDetailViewModel(_ detail:VimeoResponse.Data)->DetailViewModel{
        let vm = DetailViewModel(data: detail)
        dispatch(vm)
        return vm
    }
    
    
    private func dispatch(_ navigable:any NavigableProtocol){
        navigable.navigate.sink(receiveValue: navigate)
            .store(in: &subscription)
    }
    
   private func navigate(for action:FlowAction){
        switch action{
        case .showDetail(let detail):
            navigationPath.append(.detail(vm:makeDetailViewModel(detail)))
        }
    }
}
