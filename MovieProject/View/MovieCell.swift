//
//  MovieCell.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/25.
//

import UIKit
import Then

import RealmSwift
import RxSwift

final class MovieCell: BaseTableViewCell {

    // MARK: - Properties

    private var storage: RealmStorage
    private var movie: Movie?

    private let isStarred = PublishSubject<Bool>()
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
        self.storage = RealmStorage.shared
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
        disposeBag = DisposeBag()
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
            .map { [weak self] _ -> Bool in
                guard let self = self else { return false }
                return self.starButton.isSelected
            }
            .distinctUntilChanged()
            .emit(onNext: { [weak self] isSelected in
                guard let self = self else { return }
                if isSelected {
                    self.requestUnStar()
                } else {
                    self.requestStar()
                }
            })
            .disposed(by: disposeBag)

        isStarred
            .asSignal(onErrorJustReturn: false)
            .emit(to: starButton.rx.isSelected)
            .disposed(by: disposeBag)
    }

    /// tableView dataSource 갱신
    func handleStarBtnInfavoritesView(viewModel: FavoritesViewModel) {
        starButton.rx.tap
            .subscribe(onNext: { _ in
                viewModel.favoriteList.accept(viewModel.favorites.map{$0})
            })
            .disposed(by: self.disposeBag)
    }

    func configure(movie: Movie) {
        self.movie = movie

        if movie.image == "" {
            postImage.image = UIImage(named: "no_image")
        } else {
            postImage.setImage(with: movie.image)
        }
        titleLabel.text = (movie.title)
            .replacingOccurrences(of: "</b>", with: "")
            .replacingOccurrences(of: "<b>", with: "")
        handleEmptyData(label: directorLabel, title: "감독", data: movie.director)
        handleEmptyData(label: castLabel, title: "출연", data: movie.actor)
        gradeLabel.text = "평점: \(movie.userRating)"

        /// starButton image fill
        if !storage.load().filter("link == %@", self.movie?.link ?? "").isEmpty {
            self.isStarred.onNext(true)
        } else {
            self.isStarred.onNext(false)
        }
    }

    private func handleEmptyData(label: UILabel, title: String, data: String) {
        if data == "" {
            label.text = "\(title): 정보 없음"
        } else {
            label.text = "\(title): \(data.trimmingCharacters(in: ["|"]))"
        }
    }
}

// MARK: - Star 로직

extension MovieCell {
    private func requestStar() {
        self.isStarred.onNext(true)

        /// add realm
        if storage.load().filter("link == %@", self.movie?.link ?? "").isEmpty {
            storage.save(movie: movie)
            ProgressHUDStyle.configureHUD(
                text: StarStatus.star.description,
                icon: .star,
                color: .star
            )
        }
    }

    private func requestUnStar() {
        self.isStarred.onNext(false)

        /// remove realm
        if !storage.load().filter("link == %@", self.movie?.link ?? "").isEmpty {
            storage.delete(movie: movie)
            ProgressHUDStyle.configureHUD(
                text: StarStatus.unstar.description,
                icon: .star,
                color: .lightGray
            )
        }
    }
}

