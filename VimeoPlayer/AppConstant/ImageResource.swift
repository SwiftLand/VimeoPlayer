//
//  Images.swift
//  VimeoPlayer
//
//  Created by Ali on 2/16/23.
//

import Foundation
import UIKit

enum ImageResource:String{
    
    case error_icon = "exclamationmark.circle.fill"
    case magnifying_glass = "magnifyingglass"
    case play_round_icon = "play.circle.fill"
    case play_icon = "play.fill"
    case pause_icon = "pause.fill"
    case mute_icon = "speaker.slash.fill"
    case unMute_icon = "speaker.fill"
    case expand_icon = "arrow.up.left.and.down.right.and.arrow.up.right.and.down.left"
    case collapse_icon = "arrow.down.forward.and.arrow.up.backward"
    case person = "person.fill"
    case comment_icon = "bubble.left.and.bubble.right.fill"
    case like_icon = "heart.fill"
    
    static func getName (for image:ImageResource)->String{
        return image.rawValue
    }
    
    static func getImage (for image:ImageResource,color:UIColor = .darkGray)->UIImage{
        return  UIImage(systemName: image.rawValue)!.withTintColor(color, renderingMode: .alwaysOriginal)
    }
}
