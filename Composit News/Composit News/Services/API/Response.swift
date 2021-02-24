//
//  Response.swift
//  Composit News
//
//  Created by Lukáš Foldýna on 24.02.2021.
//

import Foundation

struct Response<Object>: Decodable where Object: Decodable {

    enum Result {
        case success(Object)
        case failure(ResponseError)
    }

    let result: Result

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        do {
            result = .success(try container.decode(Object.self))
        } catch {
            result = .failure(.decoding(error))
        }
    }

}
