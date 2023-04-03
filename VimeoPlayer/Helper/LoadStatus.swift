//
//  LoadStatus.swift
//  VimeoPlayer
//
//  Created by Ali on 2/15/23.
//

import Foundation

enum LoadStatus{
    case fetched
    case loading
    case error(error:Error)
}
