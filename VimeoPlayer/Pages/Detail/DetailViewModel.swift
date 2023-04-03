//
//  DetailViewModelC.swift
//  VimeoPlayer
//
//  Created by Ali on 3/9/23.
//

import Foundation
import Combine
import AVFoundation

final class DetailViewModel:ObservableObject,NavigableProtocol{
    
    var navigate : PassthroughSubject<FlowAction, Never> = .init()
    private var cancellable = Set<AnyCancellable>()
    
    @Published var data:VimeoResponse.Data
    @Published var status: LoadStatus?
    
    private weak var playerVM:PlayerViewModel?
    
    
    init(data:VimeoResponse.Data) {
        self.data = data
    }
    
    func viewDidAppear(with playerVM:PlayerViewModel){
         set(playerVM)
         loadVideoConfig()
    }
    
   private func set(_ playerVM:PlayerViewModel){
        self.playerVM = playerVM
        playerVM.player.currentItemPublisher().sink(receiveValue: {
           [weak self] item in
            guard let item = item else {return}
            self?.configAVItem(item)
        }).store(in: &cancellable)
    }
    
   private func loadVideoConfig(){
        status = .loading
        ApiRepository().getVideoconfig(for:  data.id)
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
                self?.configPlayer(config: value)
            }).store(in: &cancellable)
    }
    
    private func configPlayer(config:VimeoVideoConfig){
        
        guard let link = config.request?.files?.progressive.first?.url,let url = URL(string: link) else{
            return
        }
        playerVM?.setAVItem(for: url)
    }
    
    private func configAVItem(_ item:AVPlayerItem){
        item.didPlayToEndTimePublisher().sink(receiveValue: {[weak self] value in
            self?.playerVM?.reset()
        }).store(in: &cancellable)
        
        item.statusPublisher().sink(receiveValue: {[weak self] status in
            if status == .readyToPlay {
                self?.playerVM?.play()
            }
        }).store(in: &cancellable)
    }
}
