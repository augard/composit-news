//
//  MainCore.swift
//  Composit News
//
//  Created by Lukáš Foldýna on 24.02.2021.
//

import Foundation
import Combine
import ComposableArchitecture

struct MainState: Equatable {

    var articles: ArticlesState?
    var articleDetail: ArticleDetailState?

}

enum MainAction: Equatable {

    case display
    case displayArticles(ArticlesAction)
    case displayArticleDetail(ArticleDetailAction)

}

struct MainEnvironment {

    let mainQueue: AnySchedulerOf<DispatchQueue>
    let networking: Networking
    let articleService: ArticleService

}

let MainReducer: Reducer<MainState, MainAction, MainEnvironment> = Reducer.combine(
    Reducer { state, action, environment in
        switch action {
        case .display:
            state.articles = .init()
            state.articleDetail = nil

        case .displayArticles(.display):
            state.articleDetail = nil
        case let .displayArticles(.displayArticle(article)):
            state.articleDetail = .init(article: article)
        case .displayArticles:
            break

        case .displayArticleDetail:
            break
        }
        return .none
    },
    ArticlesReducer.optional().pullback(
        state: \.articles,
        action: /MainAction.displayArticles,
        environment: { ArticlesEnvironment(mainQueue: $0.mainQueue, networking: $0.networking, articleService: $0.articleService) }
    ),
    ArticleDetailReducer.optional().pullback(
        state: \.articleDetail,
        action: /MainAction.displayArticleDetail,
        environment: { ArticleDetailEnvironment(mainQueue: $0.mainQueue) }
    )
)
