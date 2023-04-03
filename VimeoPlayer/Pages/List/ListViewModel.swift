//
//  ListViewModel.swift
//  VimeoPlayer
//
//  Created by Ali on 2/14/23.
//

import Foundation
import RxFlow
import RxSwift
import RxRelay

protocol ListViewModeProtocol:BaseViewModel{
    var dataRelay: PublishRelay<[VimeoResponse.Data]> { get set }
    var statusRelay: PublishRelay<LoadStatus> { get set }
    func search(for request:SearchRequest)
    func selectItem(with data:VimeoResponse.Data)
}

class ListViewModel:BaseViewModel,ListViewModeProtocol{
     
    var loadedDate:[VimeoResponse.Data] = []{
        didSet{
            dataRelay.accept(loadedDate)
        }
    }
    var dataRelay: PublishRelay<[VimeoResponse.Data]> = .init()
    var statusRelay: PublishRelay<LoadStatus> = .init()
    var steps: PublishRelay<Step> = .init()
    
    
    private let disposeBag = DisposeBag()
    
    
    func search(for request:SearchRequest){
       
        if request.page == 1 {
            loadedDate = []
        }
        
        statusRelay.accept(.loading)
        ApiRepository().search(for: request)
            .observe(on: MainScheduler.instance).subscribe(onNext: {[weak self] VimeoResponse in
                self?.statusRelay.accept(.fetched)
                self?.loadedDate.append(contentsOf: VimeoResponse.data)
            },onError: {[weak self] error in
                print(error)
                self?.statusRelay.accept(.error(error:error))
            }).disposed(by: disposeBag)
        
    }
    
    func selectItem(with data:VimeoResponse.Data){
        steps.accept(AppSteps.showDetail(detail: data))
    }
}
