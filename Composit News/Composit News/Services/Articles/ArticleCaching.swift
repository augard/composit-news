//
//  ArticleCaching.swift
//  Composit News
//
//  Created by Lukáš Foldýna on 25.02.2021.
//

import Foundation
import GRDB

protocol ArticleCaching {

    func fetch() throws -> [Article]

    func store(_ articles: [Article]) throws

}

struct ArticleCache: ArticleCaching {

    private var databaseQueue: DatabaseQueue

    init(databaseQueue: DatabaseQueue) throws {
        self.databaseQueue = databaseQueue

        try databaseQueue.write { db in
            guard try !db.tableExists(Article.databaseTableName) else { return }

            try db.create(table: Article.databaseTableName) { table in
                table.autoIncrementedPrimaryKey("id")
                table.column(Article.Columns.title.rawValue, .text).notNull()
                table.column(Article.Columns.date.rawValue, .datetime).notNull()
                table.column(Article.Columns.articleDescription.rawValue, .text)
                table.column(Article.Columns.author.rawValue, .text)
                table.column(Article.Columns.url.rawValue, .text).notNull()
                table.column(Article.Columns.source.rawValue, .text).notNull()
                table.column(Article.Columns.image.rawValue, .text)
            }
        }
    }

    func fetch() throws -> [Article] {
        return try databaseQueue.read { db in
            try Article.fetchAll(db)
        }
    }

    func store(_ articles: [Article]) throws {
        try databaseQueue.write { db in
            try Article.deleteAll(db)
            try articles.forEach {
                try $0.insert(db)
            }
        }
    }

}
