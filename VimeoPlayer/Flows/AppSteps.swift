//
//  Steps.swift
//  VimeoPlayer
//
//  Created by Ali on 2/14/23.
//

import Foundation
import RxFlow

enum AppSteps: Step {
    case showList
    case showDetail(detail:VimeoResponse.Data)
}
