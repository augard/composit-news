//
//  ArticleServices.swift
//  Composit News
//
//  Created by Lukáš Foldýna on 24.02.2021.
//

import Foundation
import ComposableArchitecture

struct ArticleService {

    var articles: () ->  Effect<Articles, ResponseError>

}

extension ArticleService {

    static func live(articleAPI: APIArticleServicing) -> ArticleService {
        return ArticleService(
            articles: {
                articleAPI.fetchArticles()
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
