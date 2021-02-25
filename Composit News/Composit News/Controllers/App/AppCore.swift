//
//  AppCore.swift
//  Composit News
//
//  Created by Lukáš Foldýna on 24.02.2021.
//

import Foundation
import GRDB
import Reachability
import Combine
import ComposableArchitecture

struct AppState: Equatable {

    var main: MainState?

}

enum AppAction: Equatable {

    case displayMain(MainAction)

}

struct AppEnvironment {

    let mainQueue: AnySchedulerOf<DispatchQueue>
    let databaseQueue: DatabaseQueue
    let network: Networking
    let reachability: Reachability

    let articleAPI: APIArticleServicing
    let articleCache: ArticleCaching
    let articleService: ArticleService

}

let AppReducer: Reducer<AppState, AppAction, AppEnvironment> = Reducer.combine(
    Reducer { state, action, environment in
        switch action {
        case .displayMain:
            guard state.main == nil else { break }

            state.main = .init()
            return .result { .success(.displayMain(.display)) }
        }
        return .none
    },
    MainReducer.optional().pullback(
        state: \.main,
        action: /AppAction.displayMain,
        environment: { MainEnvironment(mainQueue: $0.mainQueue, networking: $0.network, articleService: $0.articleService) }
    )
)
