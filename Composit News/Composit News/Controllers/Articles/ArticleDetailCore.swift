//
//  ArticleDetailCore.swift
//  Composit News
//
//  Created by Lukáš Foldýna on 24.02.2021.
//

import Foundation
import Combine
import ComposableArchitecture

struct ArticleDetailState: Equatable {

    var article: Article

}

enum ArticleDetailAction: Equatable {

}

struct ArticleDetailEnvironment {

    let mainQueue: AnySchedulerOf<DispatchQueue>

}

let ArticleDetailReducer: Reducer<ArticleDetailState, ArticleDetailAction, ArticleDetailEnvironment> = Reducer.combine(
    Reducer { _, _, _ in
        .none
    }
)
