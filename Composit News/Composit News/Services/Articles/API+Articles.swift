//
//  API+Articles.swift
//  Composit News
//
//  Created by Lukáš Foldýna on 24.02.2021.
//

import Foundation
import ComposableArchitecture

protocol APIArticleServicing {

    func fetchArticles() -> Effect<Articles, ResponseError>

}

struct APIArticleService: APIArticleServicing {

    private let network: Networking

    init(network: Networking) {
        self.network = network
    }

    func fetchArticles() -> Effect<Articles, ResponseError> {
        let request = Request(router: .news)
        return network.doRequest(request: request).eraseToEffect()
    }

}
