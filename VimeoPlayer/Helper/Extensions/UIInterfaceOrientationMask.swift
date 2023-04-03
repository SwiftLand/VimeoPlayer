//
//  UIInterfaceOrientationMask.swift
//  VimeoPlayer
//
//  Created by Ali on 2/17/23.
//

import Foundation
import UIKit

extension UIInterfaceOrientationMask{
    
    var toUIInterfaceOrientation: UIInterfaceOrientation {
        switch self {
        case .portrait:
            return UIInterfaceOrientation.portrait
        case .portraitUpsideDown:
            return UIInterfaceOrientation.portraitUpsideDown
        case .landscapeRight:
            return UIInterfaceOrientation.landscapeRight
        case .landscapeLeft:
            return UIInterfaceOrientation.landscapeLeft
        default:
            return UIInterfaceOrientation.unknown
        }
    }
}
