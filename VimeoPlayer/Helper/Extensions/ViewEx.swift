//
//  ViewEx.swift
//  VimeoPlayer
//
//  Created by Ali on 3/11/23.
//

import Foundation
import SwiftUI

extension View {
    func onRotate(perform action: @escaping (UIInterfaceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}
