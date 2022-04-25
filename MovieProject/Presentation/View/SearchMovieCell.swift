//
//  SearchMovieCell.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/25.
//

import UIKit
import Then

import RxSwift

final class SearchMovieCell: BaseTableViewCell {

    // MARK: - Properties

    private let postImage = UIImageView()
    private let starButton = UIButton()
    private let titleLabel = DefaultLabel(font: .headline, textColor: .basic)
    private let directorLabel = DefaultLabel(font: .body, textColor: .basic)
    private let castLabel = DefaultLabel(font: .body, textColor: .basic)
    private let gradeLabel = DefaultLabel(font: .body, textColor: .basic)

    private lazy var textStackView = UIStackView(
        arrangedSubviews: [directorLabel, castLabel, gradeLabel]
    ).then {
        $0.axis = .vertical
        $0.spacing = 3
    }

    var disposeBag = DisposeBag()

    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helpers

    override func prepareForReuse() {
        super.prepareForReuse()
        postImage.image = nil
        disposeBag = DisposeBag()
    }

    override func setView() {
        super.setView()
        contentView.addSubview(postImage)
        contentView.addSubview(starButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(textStackView)
    }

    override func setConstraints() {
        super.setConstraints()
    }

    override func setConfiguration() {
        super.setConfiguration()
    }
}
