//
//  ArticleTableViewCell.swift
//  Composit News
//
//  Created by Lukáš Foldýna on 25.02.2021.
//

import UIKit
import Combine
import ComposableArchitecture
import SnapKit

final class ArticleTableViewCell: UITableViewCell {

    static let identifier = "articleCell"

    private var pictureImageView = UIImageView()
    private var headlineLabel = UILabel()
    private var bodyLabel = UILabel()
    private var dateLabel = UILabel()

    @Published var picture = UIImage() {
        didSet {
            pictureImageView.image = picture.resize(toHeight: pictureImageView.superview?.frame.height ?? 96)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let mainStack = UIStackView()
        mainStack.axis = .horizontal
        mainStack.spacing = 16
        contentView.addSubview(mainStack)
        mainStack.snp.makeConstraints {
            $0.left.equalTo(10)
            $0.right.equalTo(-10)
            $0.topMargin.bottomMargin.equalToSuperview()
        }

        let pictureBorderView = UIView()
        mainStack.addArrangedSubview(pictureBorderView)

        pictureImageView.backgroundColor = .tertiarySystemGroupedBackground
        pictureImageView.layer.cornerRadius = 6
        pictureImageView.layer.masksToBounds = true
        pictureImageView.contentMode = .scaleAspectFill
        pictureBorderView.addSubview(pictureImageView)
        pictureImageView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
            $0.width.height.equalTo(96)
        }


        let textStack = UIStackView(arrangedSubviews: [headlineLabel, bodyLabel, dateLabel])
        textStack.axis = .vertical
        textStack.spacing = 8
        mainStack.addArrangedSubview(textStack)

        headlineLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        headlineLabel.numberOfLines = 2
        headlineLabel.textColor = .label

        bodyLabel.font = UIFont.preferredFont(forTextStyle: .body)
        bodyLabel.numberOfLines = 5
        bodyLabel.textColor = .secondaryLabel

        dateLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        dateLabel.textColor = .tertiaryLabel
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(with headline: String, body: String?, date: String) {
        headlineLabel.text = headline
        bodyLabel.text = body
        bodyLabel.isHidden = body == nil
        dateLabel.text = date
        pictureImageView.image = nil

        accessoryType = .disclosureIndicator
    }

}
