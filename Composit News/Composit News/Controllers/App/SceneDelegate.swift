//
//  SceneDelegate.swift
//  Composit News
//
//  Created by Lukáš Foldýna on 24.02.2021.
//

import UIKit
import Combine
import ComposableArchitecture

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private var liveEviroment: AppEnvironment {
        let mainQueue = DispatchQueue.main.eraseToAnyScheduler()
        let network = Network(mainQueue: mainQueue)
        let articleAPI = APIArticleService(network: network)
        let articleService = ArticleService.live(articleAPI: articleAPI)
        return .init(mainQueue: mainQueue, network: network, articleAPI: articleAPI, articleService: articleService)
    }

    private var mockEnviroment: AppEnvironment {
        let mainQueue = DispatchQueue.main.eraseToAnyScheduler()
        let network = Network(mainQueue: mainQueue)
        let articleAPI = APIArticleService(network: network)
        let articleService = ArticleService.mock()
        return .init(mainQueue: mainQueue, network: network, articleAPI: articleAPI, articleService: articleService)
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let window = (scene as? UIWindowScene).map(UIWindow.init(windowScene:)) else { return }
        self.window = window

        let state = AppState()
        let reducer = AppReducer.signpost()
        let environment = liveEviroment

        let store = Store(
            initialState: state,
            reducer: reducer,
            environment: environment
        )

        let controller = AppViewController(store: store)

        window.rootViewController = controller
        window.makeKeyAndVisible()
    }


}
