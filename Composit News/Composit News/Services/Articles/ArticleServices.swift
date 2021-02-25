//
//  ArticleServices.swift
//  Composit News
//
//  Created by Lukáš Foldýna on 24.02.2021.
//

import Foundation
import Reachability
import Combine
import ComposableArchitecture

private var ArticleCancellables: [AnyCancellable] = []

struct ArticleService {

    var articles: () ->  Effect<Articles, ResponseError>

}

extension ArticleService {

    static func live(articleAPI: APIArticleServicing, articleCache: ArticleCaching, reachability: Reachability) -> ArticleService {
        return ArticleService(
            articles: {
                .future { callback in
                    if reachability.connection == .unavailable {
                        let articles = try? articleCache.fetch()
                        callback(.success(Articles(articles: articles ?? [])))
                    } else {
                        articleAPI.fetchArticles().sink { result in
                            switch result {
                            case .finished:
                                break
                            case let .failure(error):
                                callback(.failure(error))
                            }
                        } receiveValue: { result in
                            try? articleCache.store(result.articles)
                            callback(.success(result))
                        }.store(in: &ArticleCancellables)
                    }
                }
            }
        )
    }

}

#if DEBUG
extension ArticleService {

    static func mock() -> ArticleService {
        return ArticleService(
            articles: {
                return Effect(value:
                    Articles(articles: [
                        Article(date: Date(), title: "Test article", articleDescription: "Test description", author: "Lukas", url: URL(string: "https://google.com")!, source: "head", image: nil)
                    ]
                ))
            }
        )
    }

}
#endif
