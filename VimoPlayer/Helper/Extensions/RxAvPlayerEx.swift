//
//  RxAvPlayerEx.swift
//  VimoPlayer
//
//  Created by Ali on 2/16/23.
//

import Foundation
import AVFoundation
import RxSwift
import RxCocoa

extension Reactive where Base: AVPlayer {
    
    enum SeekError:Error{
        case avItemIsNill
        case notValidDuration
    }
    
    public var muted: Observable<Bool> {
      return self
        .observe(Bool.self, #keyPath(AVPlayer.isMuted))
        .map { $0 ?? false }
    }
    
    func reset()->Observable<Bool>{
        seek(to:0)
    }
    
    func seek(to second:Float)->Observable<Bool>{
        return .deferred {
            return .create{[weak base] observer in
                guard let currentItem = base?.currentItem else {
                    observer.onError(SeekError.avItemIsNill)
                    return Disposables.create()
                }
                guard currentItem.duration.isValid else {
                    observer.onError(SeekError.notValidDuration)
                    return Disposables.create()
                }
                let seekCMTime = CMTimeMakeWithSeconds(currentItem.duration.seconds*Double(second), preferredTimescale: 1000)
                base?.seek(to: seekCMTime, toleranceBefore: .zero, toleranceAfter: .zero){isFinished in
                    observer.onNext(isFinished)
                    observer.onCompleted()
                }
                return Disposables.create()
            }
        }
    }
}
