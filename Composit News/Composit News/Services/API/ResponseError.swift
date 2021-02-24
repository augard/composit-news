//
//  ResponseError.swift
//  Composit News
//
//  Created by Lukáš Foldýna on 24.02.2021.
//

import Foundation

enum ResponseError: Error, Equatable {

    case noData
    case http(Int)
    case encoding(Error)
    case decoding(Error)
    case other(Error)

    static func == (lhs: ResponseError, rhs: ResponseError) -> Bool {
        switch (lhs, rhs) {
        case (.noData, .noData):
            return true
        case let (.http(leftError), .http(rightError)):
            return leftError == rightError
        case let (.encoding(leftError), .encoding(rightError)),
             let (.decoding(leftError), .decoding(rightError)),
             let (.other(leftError), .other(rightError)):
            return leftError.localizedDescription == rightError.localizedDescription
        default:
            return false
        }
    }

}
