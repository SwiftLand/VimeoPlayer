//
//  HTTPURLResponseEx.swift
//  SwiftAudio_Example
//
//  Created by Ali on 8/21/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
extension HTTPURLResponse {
    static let errorDomain = "HTTPErrorDomain"

    var isOK: Bool {
        return (200...299).contains(self.statusCode)
    }
    
}
