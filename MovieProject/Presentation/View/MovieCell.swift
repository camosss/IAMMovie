//
//  MovieCell.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/25.
//

import UIKit
import Then

import RxSwift

final class MovieCell: BaseTableViewCell {

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
        postImage.snp.makeConstraints { make in
            make.top.equalTo(8)
            make.leading.equalTo(16)
            make.width.equalTo(80)
            make.height.equalTo(110)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(8)
            make.leading.equalTo(postImage.snp.trailing).offset(8)
        }
        starButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(40)
        }
        textStackView.snp.makeConstraints { make in
            make.top.equalTo(starButton.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(12)
        }
    }

    override func setConfiguration() {
        super.setConfiguration()
        titleLabel.numberOfLines = 2
        postImage.clipsToBounds = true
        postImage.layer.cornerRadius = 6
        postImage.contentMode = .scaleToFill
        starButton.setImage(UIImage(systemName: "star"), for: .normal)
        starButton.tintColor = .basic
    }

    func configure(movie: Movie) {
        postImage.setImage(with: movie.image ?? "")
        titleLabel.text = "\(movie.title ?? "")(\(movie.pubDate ?? ""))"
        handleEmptyData(label: directorLabel, title: "감독", data: movie.director ?? "")
        handleEmptyData(label: castLabel, title: "출연", data: movie.actor ?? "")
        gradeLabel.text = "평점: \(movie.userRating ?? "")"
    }

    private func handleEmptyData(label: UILabel, title: String, data: String) {
        if data == "" {
            label.text = "\(title): 정보 없음"
        } else {
            label.text = "\(title): \(data)"
        }
    }
}
