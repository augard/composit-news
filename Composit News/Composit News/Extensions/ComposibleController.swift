//
//  ComposibleController.swift
//  Composit News
//
//  Created by Lukáš Foldýna on 24.02.2021.
//

import UIKit
import Combine
import ComposableArchitecture

protocol ComposibleController: UIViewController {

    associatedtype State: Equatable
    associatedtype Action: Equatable

    typealias MainStore = Store<State, Action>
    typealias MainViewStore = ViewStore<State, Action>

    var cancellables: Set<AnyCancellable> { get set }
    var store: MainStore { get }
    var viewStore: MainViewStore { get }

    init(store: MainStore)

}
