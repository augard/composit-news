//
//  Request.swift
//  Composit News
//
//  Created by Lukáš Foldýna on 24.02.2021.
//

import Foundation

struct Request {

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
