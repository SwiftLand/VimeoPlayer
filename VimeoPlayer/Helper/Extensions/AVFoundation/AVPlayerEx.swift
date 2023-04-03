//
//  AVPlayerEx.swift
//  VimeoPlayer
//
//  Created by Ali on 2/15/23.
//

import Foundation
import AVFoundation
import Combine

extension AVPlayer{

    enum SeekError:Error{
        case avItemIsNill
        case notValidDuration
    }
    
    var isPlaying:Bool{ self.timeControlStatus == .playing }
    var isPaused:Bool{ self.timeControlStatus == .paused }
    
    func togglePlay(){
        if isPlaying {
            pause()
        }else{
            play()
        }
    }
    
    func toggleMute(){
        isMuted = !isMuted
    }
    
}
extension AVPlayer{
    
 func seek(to relativePoint:Double)->AnyPublisher<Bool,SeekError>{
       
        return Deferred {
            return Future{[weak self] promise in
                guard let currentItem = self?.currentItem else {
                    promise(Result.failure(SeekError.avItemIsNill))
                    return
                }
                guard currentItem.duration.isValid else {
                    promise(Result.failure(SeekError.notValidDuration))
                    return
                }
                let seekCMTime = CMTimeMakeWithSeconds(currentItem.duration.seconds*relativePoint, preferredTimescale: 1000)
                self?.seek(to: seekCMTime, toleranceBefore: .zero, toleranceAfter: .zero){isFinished in
                    promise(Result.success(isFinished))
                }
            }
        }.eraseToAnyPublisher()
  }
}

public extension AVPlayer {
    /// Wrapper around a `NSObject.KeyValueObservingPublisher` for the `rate` property
    func ratePublisher() -> AnyPublisher<Float, Never> {
        publisher(for: \.rate).eraseToAnyPublisher()
    }
    
    /// Wrapper around a `NSObject.KeyValueObservingPublisher` for the `currentItem` property
    func currentItemPublisher() -> AnyPublisher<AVPlayerItem?, Never> {
         publisher(for: \.currentItem).eraseToAnyPublisher()
    }
}

extension AVPlayer {
    func periodicTimePublisher(forInterval interval: CMTime = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))) -> AnyPublisher<CMTime, Never> {
        Publisher(self, forInterval: interval)
            .eraseToAnyPublisher()
    }
}

fileprivate extension AVPlayer {
    private struct Publisher: Combine.Publisher {
    
        typealias Output = CMTime
        typealias Failure = Never
    
        var player: AVPlayer
        var interval: CMTime

        init(_ player: AVPlayer, forInterval interval: CMTime) {
            self.player = player
            self.interval = interval
        }

        func receive<S>(subscriber: S) where S : Subscriber, Publisher.Failure == S.Failure, Publisher.Output == S.Input {
            let subscription = CMTime.Subscription(subscriber: subscriber, player: player, forInterval: interval)
            subscriber.receive(subscription: subscription)
        }
    }
}
