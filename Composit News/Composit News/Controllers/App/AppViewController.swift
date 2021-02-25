//
//  AppViewController.swift
//  Composit News
//
//  Created by Lukáš Foldýna on 24.02.2021.
//

import UIKit

final class AppViewController: BaseViewController<AppState, AppAction> {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.systemGroupedBackground

        store.scope(state: \.main, action: AppAction.displayMain)
            .ifLet(then: { [weak self] store in
                let controller = MainViewController(store: store)
                controller.modalPresentationStyle = .fullScreen
                controller.modalTransitionStyle = .crossDissolve
                self?.present(controller, animated: true)
            }, else: { [weak self] in
                self?.presentedViewController?.dismiss()
            })
            .store(in: &cancellables)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewStore.send(.displayMain(.display))
    }

}
