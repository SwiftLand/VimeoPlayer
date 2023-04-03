//
//  Formatter.swift
//  VimeoPlayer
//
//  Created by Ali on 2/16/23.
//

import Foundation
import AVFoundation
class Formatter{
    
   static func formateDuration(seacond:Int) -> String {
          let hours = seacond / 3600
          let minutes = (seacond / 60) % 60
          let seconds = seacond % 60
          if hours > 0 { return String(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds) }
          return String(format: "%0.2d:%0.2d", minutes, seconds)
      }
  
    static func formatNumber(_ n: Int) -> String {
        let num = abs(Double(n))
        let sign = (n < 0) ? "-" : ""

        switch num {
        case 1_000_000_000...:
            var formatted = num / 1_000_000_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted)B"

        case 1_000_000...:
            var formatted = num / 1_000_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted)M"

        case 1_000...:
            var formatted = num / 1_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted)K"

        case 0...:
            return "\(n)"

        default:
            return "\(sign)\(n)"
        }
    }
    
  static func formatProgress(currentTime: CMTime, duration: CMTime) -> Double {
        if !duration.isValid || !currentTime.isValid {
            return 0
        }
        
        let totalSeconds = duration.seconds
        let currentSeconds = currentTime.seconds
        
        if !totalSeconds.isFinite || !currentSeconds.isFinite {
            return 0
        }
        
        return min(currentSeconds/totalSeconds, 1)
    }

}
