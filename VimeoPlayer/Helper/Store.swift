//
//  Store.swift
//  VimeoPlayer
//
//  Created by Ali on 3/12/23.
//

import Foundation
import SwiftUI

class Store: ObservableObject {
    @Published var orientation:UIInterfaceOrientation =  (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.interfaceOrientation ?? .unknown
    convenience init(orientation: UIInterfaceOrientation) {
        self.init()
        self.orientation = orientation
    }
}
