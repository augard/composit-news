//
//  Article.swift
//  Composit News
//
//  Created by Lukáš Foldýna on 24.02.2021.
//

import Foundation

struct Articles: Decodable, Equatable {
    let articles: [Article]
}

struct Article: Decodable, Equatable, Hashable {
    let date: Date
    let title: String
    let articleDescription: String?
    let author: String?
    let url: URL
    let source: String
    let image: URL?
}
