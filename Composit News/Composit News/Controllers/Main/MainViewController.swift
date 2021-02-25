//
//  ViewController.swift
//  Composit News
//
//  Created by Lukáš Foldýna on 24.02.2021.
//

import UIKit
import Combine
import ComposableArchitecture

final class MainViewController: UINavigationController {

    typealias MainStore = Store<MainState, MainAction>
    typealias MainViewStore = ViewStore<MainState, MainAction>

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

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.prefersLargeTitles = true

        view.backgroundColor = .systemBackground

        store.scope(state: \.articles, action: MainAction.displayArticles)
            .ifLet { [weak self] store in
                self?.viewControllers = [ArticlesViewController(store: store)]
            }
            .store(in: &cancellables)

        store.scope(state: \.articleDetail, action: MainAction.displayArticleDetail)
            .ifLet { [weak self] store in
                if let controller = self?.viewControllers.first, controller is ArticlesViewController {
                    self?.pushViewController(ArticleDetailViewController(store: store), animated: true)
                } else {
                    self?.viewControllers = [ArticleDetailViewController(store: store)]
                }
            }
            .store(in: &cancellables)
    }

}
