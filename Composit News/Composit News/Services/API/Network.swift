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
    var decoder: JSONDecoder { get }

    func doRequest<V>(request: Requsting) -> AnyPublisher<V, ResponseError> where V: Decodable

}

final class Network: Networking {

    // MARK: - Networking

    let session: URLSession

    let mainQueue: AnySchedulerOf<DispatchQueue>

    var decoder: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        return jsonDecoder
    }

    private var cancellables: Set<AnyCancellable> = []

    init(mainQueue: AnySchedulerOf<DispatchQueue>) {
        self.session = URLSession(configuration: .default)
        self.mainQueue = mainQueue
    }

    func doRequest<V>(request: Requsting) -> AnyPublisher<V, ResponseError> where V: Decodable {
        return Future<Response<V>, Error> { promise in
            let urlRequest: URLRequest
            do {
                urlRequest = try request.asURLRequest()
            } catch {
                promise(.failure(ResponseError.encoding(error)))
                return
            }

            self.session.dataTaskPublisher(for: urlRequest)
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
                .store(in: &self.cancellables)
        }
        .receive(on: mainQueue)
        .tryCompactMap { response in
            switch response.result {
            case let .success(value):
                return value
            case let .failure(error):
                throw error
            }
        }
        .mapError { error in
            if let error = error as? ResponseError {
                return error
            } else {
                return .other(error)
            }
        }
        .eraseToAnyPublisher()
    }

}
