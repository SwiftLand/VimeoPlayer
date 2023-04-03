//
//  FlowScreen.swift
//  VimeoPlayer
//
//  Created by Ali on 3/12/23.
//

import Foundation
enum Screen: Hashable {
    case list(vm:ListViewModel)
    case detail(vm:DetailViewModel)
}
