//
//  AppStepper.swift
//  VimeoPlayer
//
//  Created by Ali on 2/14/23.
//

import Foundation
import RxFlow
import RxRelay

class AppStepper: Stepper {

    let steps = PublishRelay<Step>()

    var initialStep: Step {
        return AppSteps.showList
    }
}
