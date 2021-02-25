//
//  AlertData.swift
//  Composit News
//
//  Created by Lukáš Foldýna on 25.02.2021.
//

import Foundation

struct AlertData: Identifiable, Equatable {

    let id = UUID()

    var title: String
    var message: String?

    init(title: String, message: String? = nil) {
        self.title = title
        self.message = message
    }

}
