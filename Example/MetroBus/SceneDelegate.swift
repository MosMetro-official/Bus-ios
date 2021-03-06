//
//  SceneDelegate.swift
//  MetroBus
//
//  Created by Слава Платонов on 06.06.2022.
//

import Bus
import UIKit
import Localize_Swift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        Localize.setCurrentLanguage("ru")
        guard let windowScene = (scene as? UIWindowScene) else { return }
        Bus.shared.authDelegate = self
        let viewController = ViewController()
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}

extension SceneDelegate: B_AuthDelegate {
    func showAuthScreen(completion: (UIViewController) -> Void) {
        let auth = AuthViewController()
        completion(auth)
    }
}
