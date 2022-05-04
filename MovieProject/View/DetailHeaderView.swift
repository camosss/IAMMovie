//
//  DetailHeaderView.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/26.
//

import UIKit

import RxCocoa
import RxSwift

final class DetailHeaderView: BaseUIView {

    // MARK: - Properties

    private var storage: RealmStorage
    private var movieRealmData: MovieRealmDataProtocol = MovieRealmData()
    private var movie: Movie?

    private let isStarred = PublishSubject<Bool>()
    private let disposeBag = DisposeBag()

    private let postImage = UIImageView()
    private let starButton = StarButton()
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
        self.storage = RealmStorage.shared
        super.init(frame: frame)
        bind()
    }

    required init?(coder: NSCoder) {
        self.storage = RealmStorage.shared
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

        ViewHelper.handleImageData(imageView: postImage, data: movie.image)
        ViewHelper.handleEmptyData(label: directorLabel, title: "감독", data: movie.director)
        ViewHelper.handleEmptyData(label: castLabel, title: "출연", data: movie.actor)
        ViewHelper.handleRatingData(label: gradeLabel, data: movie.userRating)

        /// starButton image fill
        if !storage.load().filter("link == %@", self.movie?.link ?? "").isEmpty {
            self.isStarred.onNext(true)
        } else {
            self.isStarred.onNext(false)
        }
    }
}

// MARK: - Star 로직

extension DetailHeaderView {
    private func requestStar() {
        self.isStarred.onNext(true)

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
        self.isStarred.onNext(false)

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
