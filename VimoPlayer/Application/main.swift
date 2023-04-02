//
//  main.swift
//  VimoPlayer
//
//  Created by Ali on 2/14/23.
//

import Foundation
import UIKit

let appDelegate: String? = NSClassFromString("XCTestCase") == nil ? NSStringFromClass(AppDelegate.self) : nil

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, appDelegate)
