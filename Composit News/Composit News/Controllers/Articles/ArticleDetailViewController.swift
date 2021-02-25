//
//  ArticleDetailViewController.swift
//  Composit News
//
//  Created by Lukáš Foldýna on 24.02.2021.
//

import Foundation
import SnapKit
import WebKit

final class ArticleDetailViewController: BaseViewController<ArticleDetailState, ArticleDetailAction> {

    private var webView = WKWebView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()

        viewStore.publisher.article
            .sink { [weak self] article in
                self?.setupContent(article)
            }
            .store(in: &cancellables)
    }

    // MARK: - Actions

    @objc private func toShare(_ sender: Any?) {
        let controller = UIActivityViewController(activityItems: [viewStore.article.url], applicationActivities: nil)
        controller.modalPresentationStyle = .popover
        controller.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
        present(controller, animated: true)
    }

}

private extension ArticleDetailViewController {

    func setupLayout() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(toShare(_:)))

        view.addSubview(webView)
        webView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
    }

    func setupContent(_ article: Article) {
        title = article.title

        webView.load(URLRequest(url: article.url))
    }

}
