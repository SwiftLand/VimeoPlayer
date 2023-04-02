//
//  ListViewModel.swift
//  VimoPlayer
//
//  Created by Ali on 2/14/23.
//

import Foundation
import RxFlow
import RxSwift
import RxRelay

protocol ListViewModeProtocol:BaseViewModel{
    var dataRelay: PublishRelay<[VimoResponse.Data]> { get set }
    var statusRelay: PublishRelay<LoadStatus> { get set }
    func search(for request:SearchRequest)
    func selectItem(with data:VimoResponse.Data)
}

class ListViewModel:BaseViewModel,ListViewModeProtocol{
    
    lazy var apiRepository:ApiRepositoryProtocol = ApiRepository()
    
    var loadedDate:[VimoResponse.Data] = []{
        didSet{
            dataRelay.accept(loadedDate)
        }
    }
    var dataRelay: PublishRelay<[VimoResponse.Data]> = .init()
    var statusRelay: PublishRelay<LoadStatus> = .init()
    var steps: PublishRelay<Step> = .init()
    
    
    private let disposeBag = DisposeBag()
    
    
    func search(for request:SearchRequest){
       
        if request.page == 1 {
            loadedDate = []
//            dataRelay.accept([])
        }
        
        statusRelay.accept(.loading)
        apiRepository.search(for: request)
            .observe(on: MainScheduler.instance).subscribe(onNext: {[weak self] vimoResponse in
                self?.statusRelay.accept(.fetched)
                self?.loadedDate.append(contentsOf: vimoResponse.data)
//                self?.dataRelay.accept(loadedDate)
            },onError: {[weak self] error in
                print(error)
                self?.statusRelay.accept(.error(error:error))
            }).disposed(by: disposeBag)
        
    }
    
    func selectItem(with data:VimoResponse.Data){
        steps.accept(AppSteps.showDetail(detail: data))
    }
}
