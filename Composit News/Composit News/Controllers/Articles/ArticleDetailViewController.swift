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

        view.addSubview(webView)
        webView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        webView.load(URLRequest(url: viewStore.article.url))
    }

}
