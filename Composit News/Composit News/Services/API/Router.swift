//
//  Router.swift
//  Composit News
//
//  Created by Lukáš Foldýna on 24.02.2021.
//

import Foundation

enum Router: String {

    static let baseURLString = URL(string: "https://api.lil.software")!

    enum Method: String {
        case get = "GET"
        case post = "POST"
    }

    case news = "news"

    var method: Method {
        switch self {
        case .news:
            return .get
        }
    }

    func asURL() throws -> URL {
        guard let url = URL(string: rawValue, relativeTo: Self.baseURLString) else {
            throw RouterError.failedToCreateURL
        }
        return url
    }

}
