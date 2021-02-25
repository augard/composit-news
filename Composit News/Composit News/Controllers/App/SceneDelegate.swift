//
//  SceneDelegate.swift
//  Composit News
//
//  Created by Lukáš Foldýna on 24.02.2021.
//

import UIKit
import GRDB
import Reachability
import Combine
import ComposableArchitecture

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private var databaseURL: URL {
        #if TARGET_IPHONE_SIMULATOR
        let path = (NSTemporaryDirectory() as NSString).appendingPathComponent("database.sqlite")
        #else
        let path = (NSHomeDirectory() as NSString).appendingPathComponent("tmp/database.sqlite")
        #endif
        return URL(fileURLWithPath: path)
    }

    private var liveEviroment: AppEnvironment {
        let mainQueue = DispatchQueue.main.eraseToAnyScheduler()
        let network = Network(mainQueue: mainQueue)
        let databaseQueue = try! DatabaseQueue(path: databaseURL.path)
        let reachability = try! Reachability(hostname: Router.baseURLString.host ?? "")
        let articleAPI = APIArticleService(network: network)
        let articleCache = try! ArticleCache(databaseQueue: databaseQueue)
        let articleService = ArticleService.live(articleAPI: articleAPI, articleCache: articleCache, reachability: reachability)
        return .init(
            mainQueue: mainQueue, databaseQueue: databaseQueue, network: network, reachability: reachability,
            articleAPI: articleAPI, articleCache: articleCache, articleService: articleService
        )
    }

    private var mockEnviroment: AppEnvironment {
        let mainQueue = DispatchQueue.main.eraseToAnyScheduler()
        let network = Network(mainQueue: mainQueue)
        let databaseQueue = try! DatabaseQueue(path: databaseURL.path)
        let reachability = try! Reachability(hostname: Router.baseURLString.host ?? "")
        let articleAPI = APIArticleService(network: network)
        let articleCache = try! ArticleCache(databaseQueue: databaseQueue)
        let articleService = ArticleService.mock()
        return .init(
            mainQueue: mainQueue, databaseQueue: databaseQueue, network: network, reachability: reachability,
            articleAPI: articleAPI, articleCache: articleCache, articleService: articleService
        )
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

        try? environment.reachability.startNotifier()

        let controller = AppViewController(store: store)

        window.rootViewController = controller
        window.makeKeyAndVisible()
    }


}
