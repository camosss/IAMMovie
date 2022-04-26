//
//  DetailHeaderView.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/26.
//

import UIKit

final class DetailHeaderView: BaseUIView {

    // MARK: - Properties

    private let postImage = UIImageView()
    private let starButton = UIButton()
    private let directorLabel = DefaultLabel(font: .subHead, textColor: .basic)
    private let castLabel = DefaultLabel(font: .subHead, textColor: .basic)
    private let gradeLabel = DefaultLabel(font: .subHead, textColor: .basic)

    private lazy var textStackView = UIStackView(
        arrangedSubviews: [directorLabel, castLabel, gradeLabel]
    ).then {
        $0.axis = .vertical
        $0.spacing = 6
    }

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Helpers

    override func setView() {
        super.setView()
        addSubview(postImage)
        addSubview(starButton)
        addSubview(textStackView)
    }

    override func setConstraints() {
        super.setConstraints()
        postImage.snp.makeConstraints { make in
            make.top.equalTo(8)
            make.leading.equalTo(16)
            make.width.equalTo(60)
            make.height.equalTo(80)
        }
        textStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().inset(8)
            make.leading.equalTo(postImage.snp.trailing).offset(12)
        }
        starButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(textStackView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(40)
        }
    }

    override func setConfiguration() {
        super.setConfiguration()
        postImage.clipsToBounds = true
        postImage.layer.cornerRadius = 6
        postImage.contentMode = .scaleToFill
        starButton.setImage(UIImage(systemName: "star"), for: .normal)
        starButton.contentMode = .scaleAspectFit
        starButton.tintColor = .basic
    }

    func configure(movie: Movie) {
        if movie.image == "" {
            postImage.image = UIImage(named: "no_image")
        } else {
            postImage.setImage(with: movie.image ?? "")
        }
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
