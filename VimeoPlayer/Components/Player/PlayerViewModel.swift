//
//  PlayerViewModel.swift
//  VimeoPlayer
//
//  Created by Ali on 3/10/23.
//

import Foundation
import AVFoundation
import Combine
 
class PlayerViewModel:ObservableObject{
    
    private(set) var player:AVPlayer = AVPlayer()
    
    @Published var isPlay:Bool = false
    @Published var isExpanded:Bool = false
    @Published var progressValue:Double = 0
    
    private var cancellable = Set<AnyCancellable>()
    private var progressCancellable:AnyCancellable?
    private var isPlayingBeforeSeek:Bool = false
    
    
    func setAVItem(for url:URL){
        
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
        setupProgressObservation(item: item)
        
        player.publisher(for: \.timeControlStatus)
            .sink {[weak self] status in
                guard status != .waitingToPlayAtSpecifiedRate else {return}
                self?.isPlay = status == .playing
            }
            .store(in: &cancellable)
    }

    func play(){
        player.play()
    }
    
    func pause(){
        player.pause()
    }
    
    func reset(){
        seek(to: 0)
    }

    func onDrageSliderStart(){
        progressCancellable?.cancel()
    }
    
    func onDrageSliderEnd(){
        seekToSliderPostion()
    }
    
    func seekToSliderPostion(){
        seek(to:progressValue)
    }
    
    func seek(to relativePoint:Double){
        isPlayingBeforeSeek = player.isPlaying
        player.pause()
        player.seek(to: relativePoint).sink(receiveCompletion: {[weak self] result in
            switch result{
            case .finished:
                guard let self = self else {return}
                self.resumePlayerAfterSeek()
                if let item = self.player.currentItem{
                    self.setupProgressObservation(item: item)
                }
            default:break
            }
        }, receiveValue: {_ in}).store(in: &cancellable)
    }
    
    private func resumePlayerAfterSeek(){
        if isPlayingBeforeSeek{
            player.play()
        }
    }
    
    private func setupProgressObservation(item: AVPlayerItem) {
        progressCancellable = player.periodicTimePublisher()
        .receive(on: DispatchQueue.main)
        .map({Formatter.formatProgress(currentTime: $0, duration: item.duration)})
        .sink(receiveValue: {[weak self] value in
            self?.progressValue = value
        })
    }

    
    private func updatePlayStatus(_ status:AVPlayer.TimeControlStatus){
        isPlay = status == .playing
    }

}
