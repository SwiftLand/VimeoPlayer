//
//  DetailViewModel.swift
//  VimeoPlayer
//
//  Created by Ali on 2/14/23.
//

import Foundation
import RxFlow
import RxRelay
import RxSwift

protocol DetailViewModelProtocol:BaseViewModel{
    var data:VimeoResponse.Data {get}
    var videoConfig: PublishRelay<VimeoVideoConfig> { get set }
    var status: PublishRelay<LoadStatus> { get set }
    func loadVideoConfig()
}
class DetailViewModel:BaseViewModel,DetailViewModelProtocol{

    var data:VimeoResponse.Data
    var videoConfig: PublishRelay<VimeoVideoConfig> = .init()
    var status: PublishRelay<LoadStatus> = .init()
    var steps: PublishRelay<Step> = .init()
    
    private let disposeBag = DisposeBag()
    
    init(data:VimeoResponse.Data) {
        self.data = data
    }

    func loadVideoConfig(){
        
        status.accept(.loading)
        ApiRepository().getVideoconfig(for: data.id)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[weak self] VimeoVideoConfig in
                self?.status.accept(.fetched)
                self?.videoConfig.accept(VimeoVideoConfig)
            },onError: {[weak self] error in
                print(error)
                self?.status.accept(.error(error:error))
            }).disposed(by: disposeBag)
        
    }
}
