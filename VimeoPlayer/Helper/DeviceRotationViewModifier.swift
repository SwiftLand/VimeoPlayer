//
//  DetectOrientation.swift
//  VimeoPlayer
//
//  Created by Ali on 3/11/23.
//

import Foundation
import SwiftUI

struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIInterfaceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                let orientation = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.interfaceOrientation
                action(orientation ?? .unknown)
            }
    }
}
