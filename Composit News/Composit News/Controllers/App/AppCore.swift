//
//  AppCore.swift
//  Composit News
//
//  Created by Lukáš Foldýna on 24.02.2021.
//

import Foundation
import Combine
import ComposableArchitecture

struct AppState: Equatable {

    var main: MainState?

}

enum AppAction: Equatable {

    case displayMain(MainAction)
    case displayResult(Result<Articles, ResponseError>)

}

struct AppEnvironment {

    let mainQueue: AnySchedulerOf<DispatchQueue>

    let network: Networking
    let articleAPI: APIArticleServicing

    let articleService: ArticleService

    init() {
        mainQueue = DispatchQueue.main.eraseToAnyScheduler()
        network = Network()
        articleAPI = APIArticleService(network: network)
        articleService = ArticleService.live(articleAPI: articleAPI)
    }

    init(mainQueue: AnySchedulerOf<DispatchQueue>, network: Networking, articleAPI: APIArticleServicing, articleService: ArticleService) {
        self.mainQueue = mainQueue
        self.network = network
        self.articleAPI = articleAPI
        self.articleService = articleService
    }

}

let AppReducer: Reducer<AppState, AppAction, AppEnvironment> = Reducer.combine(
    Reducer { state, action, environment in
        switch action {
        case let .displayMain(action):
            struct RequestID: Hashable, Equatable {
                let id = UUID()
            }

            return environment.articleService.articles()
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(AppAction.displayResult)
                .cancellable(id: RequestID(), cancelInFlight: true)
        case let .displayResult(.success(articles)):
            print("Success: \(articles)")
        case let .displayResult(.failure(error)):
            print("Failure: \(error)")
        }
        return .none
    }
)
