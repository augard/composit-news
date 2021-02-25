//
//  Article.swift
//  Composit News
//
//  Created by Lukáš Foldýna on 24.02.2021.
//

import Foundation
import GRDB

struct Articles: Decodable, Equatable {

    init(articles: [Article]) {
        self.articles = articles
    }

    let articles: [Article]

}

struct Article: Decodable, Equatable, Hashable {

    var id: Int64?
    let date: Date
    let title: String
    let articleDescription: String?
    let author: String?
    let url: URL
    let source: String
    let image: URL?

}

extension Article: FetchableRecord {

    enum Columns: String, ColumnExpression {
        case id, date, title, articleDescription, author, url, source, image
    }

    init(row: Row) {
        id = row[Columns.id]
        date = row[Columns.date]
        title = row[Columns.title]
        articleDescription = row[Columns.articleDescription]
        author = row[Columns.author]
        url = row[Columns.url]
        source = row[Columns.source]
        image = row[Columns.image]
    }

}

extension Article: TableRecord { }

extension Article: PersistableRecord {

    func encode(to container: inout PersistenceContainer) {
        container[Columns.id] = id
        container[Columns.date] = date
        container[Columns.title] = title
        container[Columns.articleDescription] = articleDescription
        container[Columns.author] = author
        container[Columns.url] = url
        container[Columns.source] = source
        container[Columns.image] = image
    }

    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }

}
