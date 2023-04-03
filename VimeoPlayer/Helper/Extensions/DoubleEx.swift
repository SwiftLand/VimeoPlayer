//
//  DoubleEx.swift
//  VimeoPlayer
//
//  Created by Ali on 2/17/23.
//

import Foundation
extension Double {
    func reduceScale(to places: Int) -> Double {
        let multiplier = pow(10, Double(places))
        let newDecimal = multiplier * self
        let truncated = Double(Int(newDecimal))
        let originalDecimal = truncated / multiplier
        return originalDecimal
    }
}
