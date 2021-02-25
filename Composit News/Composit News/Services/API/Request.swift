//
//  Request.swift
//  Composit News
//
//  Created by Lukáš Foldýna on 24.02.2021.
//

import Foundation

protocol Requsting {

    func asURLRequest() throws -> URLRequest

}

struct Request: Requsting {

    let router: Router

    var body: Data?

    init(router: Router, body: Data? = nil) {
        self.router = router
        self.body = body
    }

    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: try router.asURL())
        urlRequest.httpMethod = router.method.rawValue
        if let body = body {
            urlRequest.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = body
        } else {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.httpMethod = router.method.rawValue
        return urlRequest
    }

}

struct RequestURL: Requsting {

    let url: URL
    let method: Router.Method

    init(url: URL, method: Router.Method = .get) {
        self.url = url
        self.method = method
    }

    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }

}
