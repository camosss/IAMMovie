//
//  FavoritesViewModel.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/27.
//

import Foundation

import RealmSwift
import RxCocoa
import RxSwift

final class FavoritesViewModel {

    // MARK: - Properties

    var favoriteList = BehaviorRelay<[Movie]>(value: [])

    let refreshControlAction = PublishRelay<Void>() /// 새로고침 실행 여부를 수신
    let refreshControlCompelted = PublishRelay<Void>() /// 새로고침 완료 여부를 수신

    private var movieRealmData: MovieRealmDataProtocol
    private let disposeBag = DisposeBag()

    // MARK: - Initializer

    init(movieRealmData: MovieRealmDataProtocol = MovieRealmData()) {
        self.movieRealmData = movieRealmData
        bind()
    }

    // MARK: - Helpers

    private func bind() {
        populateFavoritesList()

        refreshControlAction
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.refreshControlTriggered()
            }
            .disposed(by: disposeBag)
    }

    /// 새로고침 제어가 트리거되는 즉시, 이전 요청이 취소되고 다시 불러오기
    private func refreshControlTriggered() {
        populateFavoritesList()
        refreshControlCompelted.accept(()) /// 완료여부 이벤트 전달
    }

    private func populateFavoritesList() {
        let favorites = movieRealmData.loadMovie()
        favoriteList.accept(favorites.sorted(by: { $0.title < $1.title }))
    }
}
