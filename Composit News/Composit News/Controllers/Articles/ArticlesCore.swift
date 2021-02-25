//
//  ArticlesCore.swift
//  Composit News
//
//  Created by Lukáš Foldýna on 24.02.2021.
//

import Foundation
import Combine
import ComposableArchitecture

struct ArticlesState: Equatable {

    var articles: [Article] = []

    var isRequestInFlight: Bool = false
    var isRefreshing: Bool = false
    var alertData: AlertData?

}

enum ArticlesAction: Equatable {

    case display
    case displayResult(Result<Articles, ResponseError>)
    case refresh
    case displayArticle(Article)

    case alertDismissed

}

struct ArticlesEnvironment {

    let mainQueue: AnySchedulerOf<DispatchQueue>
    let articleService: ArticleService

}

let ArticlesReducer: Reducer<ArticlesState, ArticlesAction, ArticlesEnvironment> = Reducer.combine(
    Reducer { state, action, environment in
        switch action {
        case .display:
            if !state.articles.isEmpty || state.isRefreshing || state.isRequestInFlight {
                break
            }
            state.isRequestInFlight = true
            state.isRefreshing = false

            return environment.articleService.articles()
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ArticlesAction.displayResult)
                .cancellable(id: RequestID(), cancelInFlight: true)
        case .refresh:
            state.isRequestInFlight = false
            state.isRefreshing = true

            return environment.articleService.articles()
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(ArticlesAction.displayResult)
                .cancellable(id: RequestID(), cancelInFlight: true)

        case let .displayResult(.success(result)):
            state.articles = result.articles
            state.isRefreshing = false
            state.isRequestInFlight = false

            print("\(result)")
        case let .displayResult(.failure(error)):
            state.isRefreshing = false
            state.isRequestInFlight = false
            state.alertData = AlertData(title: "Failed to load articles", message: error.localizedDescription)

        case .displayArticle:
            break

        case .alertDismissed:
            state.alertData = nil

        }
        return .none
    }
)
