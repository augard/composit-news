//
//  RemoteImageView.swift
//  Composit News
//
//  Created by Lukáš Foldýna on 25.02.2021.
//

import UIKit
import Combine
import ComposableArchitecture

class RemoteImage: ObservableObject {

    @Published var image = UIImage()

    @Published var loadingError: Error?

    private var imageURL: URL

    private var cancellable: AnyCancellable?

    init(networking: Networking, imageURL: URL) {
        self.imageURL = imageURL
        do {
            let request = try RequestURL(url: imageURL).asURLRequest()
            cancellable = networking.session.dataTaskPublisher(for: request)
                .eraseToAnyPublisher()
                .sink(receiveCompletion: { [weak self] result in
                    switch result {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.image = UIImage()
                        self?.loadingError = error
                    }
                }, receiveValue: { [weak self] data, response in
                    self?.image = UIImage(data: data) ?? UIImage()
                })

        } catch {
            loadingError = error
        }
    }

}

extension RemoteImage: Equatable {

    static func == (lhs: RemoteImage, rhs: RemoteImage) -> Bool {
        lhs.imageURL == rhs.imageURL
    }

}
