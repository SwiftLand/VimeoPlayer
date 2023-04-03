//
//  SceneDelegate.swift
//  VimeoPlayer
//
//  Created by Ali on 2/14/23.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        window.rootViewController = UIHostingController(rootView:FlowView())
        window.makeKeyAndVisible()
    }
}

