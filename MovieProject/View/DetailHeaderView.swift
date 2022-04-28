//
//  DetailHeaderView.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/26.
//

import UIKit

import RealmSwift
import RxCocoa
import RxSwift

final class DetailHeaderView: BaseUIView {

    // MARK: - Properties

    private let realm = try! Realm()
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
        super.init(frame: frame)
        bind()
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

    func configure(movie: Movie) {
        self.movie = movie

        if movie.image == "" {
            postImage.image = UIImage(named: "no_image")
        } else {
            postImage.setImage(with: movie.image ?? "")
        }
        handleEmptyData(label: directorLabel, title: "감독", data: movie.director ?? "")
        handleEmptyData(label: castLabel, title: "출연", data: movie.actor ?? "")
        gradeLabel.text = "평점: \(movie.userRating ?? "")"

        /// starButton image fill
        if !realm.objects(Movie.self)
            .filter("link == '\(self.movie?.link ?? "")'").isEmpty {
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

extension DetailHeaderView {
    private func requestStar() {
        self.isStarred.onNext(true)

        /// add realm
        if realm.objects(Movie.self)
            .filter("link == '\(self.movie?.link ?? "")'").isEmpty {
            try! realm.write({
                /// realm 객체에 Json을 전달하는 대신 객체를 먼저 복사한 후 복제된 객체를 저장
                let copyMovie = self.realm.create(Movie.self, value: movie!, update: .all)
                self.realm.add(copyMovie)
            })
        }
    }

    private func requestUnStar() {
        self.isStarred.onNext(false)

        /// remove realm
        if !realm.objects(Movie.self)
            .filter("link == '\(self.movie?.link ?? "")'").isEmpty {
            try! realm.write({
                let copyMovie = self.realm.create(Movie.self, value: movie!, update: .all)
                self.realm.delete(copyMovie)
            })
        }
    }
}
