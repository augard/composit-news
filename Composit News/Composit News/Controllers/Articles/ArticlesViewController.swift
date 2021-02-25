//
//  ArticlesViewController.swift
//  Composit News
//
//  Created by Lukáš Foldýna on 24.02.2021.
//

import UIKit
import SnapKit
import Combine
import ComposableArchitecture

final class ArticlesViewController: BaseViewController<ArticlesState, ArticlesAction> {

    private var tableView = UITableView(frame: .zero, style: .insetGrouped)

    private var articles: [Article] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()

        viewStore.publisher.articles
            .sink { [weak self] articles in
                guard !articles.isEmpty else { return }
                self?.setupContent(articles)
            }
            .store(in: &cancellables)

        viewStore.publisher.isRequestInFlight
            .sink { [weak self] isRequestInFlight in
                isRequestInFlight ? self?.showProgress() : self?.hideProgress()
            }
            .store(in: &cancellables)

        viewStore.publisher.isRefreshing
            .sink { [weak self] isRefreshing in
                if isRefreshing {
                    self?.tableView.refreshControl?.beginRefreshing()
                } else {
                    self?.tableView.refreshControl?.endRefreshing()
                }
            }.store(in: &cancellables)

        viewStore.publisher.alertData
            .sink { [weak self] alertData in
                guard let self = self, let alertData = alertData else { return }
                self.showAlert(title: alertData.title, message: alertData.message ?? "") { [weak self] in
                    self?.viewStore.send(.alertDismissed)
                }
            }
            .store(in: &cancellables)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewStore.send(.display)
    }

    // MARK: - Actions

    @objc private func toRefresh(_ sender: Any?) {
        viewStore.send(.refresh)
    }

    private func toArticle(_ article: Article) {
        viewStore.send(.displayArticle(article))
    }

}

extension ArticlesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let article = articles[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "id")
        cell.textLabel?.text = article.title
        cell.detailTextLabel?.text = article.articleDescription
        return cell
    }

}

extension ArticlesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        toArticle(articles[indexPath.row])
    }

}

private extension ArticlesViewController {

    func setupLayout() {
        title = "Latest News"

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }

        setupRefreshControl()
    }

    func setupContent(_ articles: [Article]) {
        self.articles = articles
        tableView.reloadData()
    }

    func setupRefreshControl() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(toRefresh(_:)), for: .valueChanged)
        tableView.refreshControl = refresh
    }

}
