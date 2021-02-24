//
//  BaseViewController.swift
//  Composit News
//
//  Created by Lukáš Foldýna on 24.02.2021.
//

import UIKit
import Combine
import ComposableArchitecture

class BaseViewController<State, Action>: UIViewController, ComposibleController where State: Equatable, Action: Equatable {

    typealias MainStore = Store<State, Action>
    typealias MainViewStore = ViewStore<State, Action>

    var cancellables: Set<AnyCancellable> = []
    let store: MainStore
    let viewStore: MainViewStore

    required init(store: MainStore) {
        self.store = store
        self.viewStore = ViewStore(store)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
