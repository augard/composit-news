//
//  ArticleServices.swift
//  Composit News
//
//  Created by Lukáš Foldýna on 24.02.2021.
//

import Foundation
import ComposableArchitecture

struct ArticleService {

    var articles: () ->  Effect<[String], ResponseError>

}

extension ArticleService {

    static func live(articleAPI: APIArticleServicing) -> ArticleService {
        return ArticleService(
            articles: {
                return Effect(value: ["Test"])
            }
        )
    }

}

#if DEBUG
extension ArticleService {

    static func mock() -> ArticleService {
        return ArticleService(
            articles: {
                return Effect(value: ["Test"])
            }
        )
    }

}
#endif
