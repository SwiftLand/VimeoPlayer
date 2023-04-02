//
//  AVPlayerEx.swift
//  VimoPlayer
//
//  Created by Ali on 2/15/23.
//

import Foundation
import AVFoundation
import RxSwift
import RxRelay

extension AVPlayer{

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
