//
//  Network.swift
//  Composit News
//
//  Created by Lukáš Foldýna on 24.02.2021.
//

import Foundation
import Combine
import ComposableArchitecture

typealias NetworkResponse<Value, Error> = (_ response: Result<Value, Error>) -> Void where Value: Decodable, Error: Swift.Error

protocol Networking: class {

    var session: URLSession { get }

    var dateFormatter: DateFormatter { get }
    var decoder: JSONDecoder { get }

    func doRequest<V>(request: Request) -> AnyPublisher<V, ResponseError> where V: Decodable

}

class Network: Networking {

    // MARK: - Networking

    let session: URLSession

    init() {
        session = URLSession(configuration: .default)
    }

    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter
    }

    var decoder: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }

    func doRequest<V>(request: Request) -> AnyPublisher<V, ResponseError> where V: Decodable {
        return Future<Response<V>, Error> { promise in
            let urlRequest: URLRequest
            do {
                urlRequest = try request.asURLRequest()
            } catch {
                promise(.failure(ResponseError.encoding(error)))
                return
            }

            _ = self.session.dataTaskPublisher(for: urlRequest)
                .tryMap { output -> Data in
                    guard let response = output.response as? HTTPURLResponse else {
                        throw ResponseError.noData
                    }

                    guard response.statusCode == 200 else {
                        throw ResponseError.http(response.statusCode)
                    }
                    return output.data
                }
                .decode(type: Response<V>.self, decoder: self.decoder)
                .eraseToAnyPublisher()
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }, receiveValue: { value in
                    promise(.success(value))
                })
        }.tryCompactMap { response in
            switch response.result {
            case let .success(value):
                return value
            case let .failure(error):
                throw error
            }
        }.mapError { error in
            if let error = error as? ResponseError {
                return error
            } else {
                return .other(error)
            }
        }
        .eraseToAnyPublisher()
    }

}
