//
//  NavigableProtocol.swift
//  VimeoPlayer
//
//  Created by Ali on 3/12/23.
//

import Foundation
import Combine

protocol NavigableProtocol: AnyObject, Identifiable, Hashable {
    var navigate: PassthroughSubject<FlowAction, Never> { get }
}

extension NavigableProtocol {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
