//
//  SceneDelegate.swift
//  VimoPlayer
//
//  Created by Ali on 2/14/23.
//

import UIKit
import RxFlow

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator = FlowCoordinator()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        createFlow(window: window)
    }

    private func createFlow(window:UIWindow) {
        
        let appFlow = AppFlow()
        self.coordinator.coordinate(flow: appFlow, with: AppStepper())

        Flows.use(appFlow, when: .created) { root in
            window.rootViewController = root
            window.makeKeyAndVisible()
        }
        
    }

}

