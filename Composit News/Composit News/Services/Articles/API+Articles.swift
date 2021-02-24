//
//  API+Articles.swift
//  Composit News
//
//  Created by Lukáš Foldýna on 24.02.2021.
//

import Foundation

protocol APIArticleServicing {

}

struct APIArticleService: APIArticleServicing {

    private let network: Networking

    init(network: Networking) {
        self.network = network
    }

}
