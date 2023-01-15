//
//  MovieTableViewCell.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/25.
//

import UIKit
import Then

import RxCocoa
import RxSwift

final class MovieTableViewCell: BaseTableViewCell {

    // MARK: - Properties

    private var movie: Movie?

    private var storage: RealmStorageProtocol = RealmStorage()
    private var movieRealmData: MovieRealmDataProtocol = MovieRealmData()

    private let isStarred = PublishRelay<Bool>()
    var disposeBag = DisposeBag()

    private let postImage = UIImageView()
    private let starButton = StarButton()
    private let titleLabel = DefaultLabel(font: .headline, textColor: .basic)
    private let directorLabel = DefaultLabel(font: .subHead, textColor: .basic)
    private let castLabel = DefaultLabel(font: .subHead, textColor: .basic)
    private let gradeLabel = DefaultLabel(font: .subHead, textColor: .basic)

    private lazy var textStackView = UIStackView(
        arrangedSubviews: [directorLabel, castLabel, gradeLabel]
    ).then {
        $0.axis = .vertical
        $0.spacing = 3
    }

    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        bind()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helpers

    override func prepareForReuse() {
        super.prepareForReuse()
        postImage.image = nil
        disposeBag = DisposeBag() /// cell별로 모든 Observable 초기화
        bind()
    }

    override func setView() {
        super.setView()
        addSubview(postImage)
        addSubview(starButton)
        addSubview(titleLabel)
        addSubview(textStackView)
    }

    override func setConstraints() {
        super.setConstraints()
        postImage.snp.makeConstraints { make in
            make.top.equalTo(8)
            make.leading.equalTo(16)
            make.width.equalTo(80)
            make.height.equalTo(105)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(8)
            make.leading.equalTo(postImage.snp.trailing).offset(12)
        }
        starButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(40)
        }
        textStackView.snp.makeConstraints { make in
            make.top.equalTo(starButton.snp.bottom).offset(12)
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
    }

    private func bind() {
        starButton.rx.tap
            .asSignal()
            .throttle(.seconds(1))
            .withUnretained(self)
            .map { (owner, _) -> Bool in
                return owner.starButton.isSelected
            }
            .distinctUntilChanged()
            .withUnretained(self)
            .emit(onNext: { owner, isSelected in
                if isSelected {
                    owner.requestUnStar()
                } else {
                    owner.requestStar()
                }
            })
            .disposed(by: disposeBag)

        isStarred
            .asSignal(onErrorJustReturn: false)
            .emit(to: starButton.rx.isSelected)
            .disposed(by: disposeBag)
    }

    func configure(movie: Movie) {
        self.movie = movie

        titleLabel.text = movie.title

        ViewHelper.handleImageData(imageView: postImage, data: movie.image)
        ViewHelper.handleEmptyData(label: directorLabel, title: "감독", data: movie.director)
        ViewHelper.handleEmptyData(label: castLabel, title: "출연", data: movie.actor)
        ViewHelper.handleRatingData(label: gradeLabel, data: movie.userRating)

        /// starButton image fill
        if !storage.load().filter("link == %@", self.movie?.link ?? "").isEmpty {
            self.isStarred.accept(true)
        } else {
            self.isStarred.accept(false)
        }
    }
}

// MARK: - Star 로직

extension MovieTableViewCell {
    private func requestStar() {
        self.isStarred.accept(true)

        if storage.load().filter("link == %@", self.movie?.link ?? "").isEmpty {
            movieRealmData.saveMovie(movie: movie) /// add realm
            ProgressHUDStyle.configureHUD(
                text: StarStatus.star.description,
                icon: .star,
                color: .star
            )
        }
    }

    private func requestUnStar() {
        self.isStarred.accept(false)

        if !storage.load().filter("link == %@", self.movie?.link ?? "").isEmpty {
            movieRealmData.deleteMovie(movie: movie) /// remove realm
            ProgressHUDStyle.configureHUD(
                text: StarStatus.unstar.description,
                icon: .star,
                color: .lightGray
            )
        }
    }
}

