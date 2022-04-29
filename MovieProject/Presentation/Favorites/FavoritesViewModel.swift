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

    private let disposeBag = DisposeBag()

    var favoriteList = BehaviorRelay<[Movie]>(value: [])
    let refreshControlAction = PublishSubject<Void>() /// 새로고침 실행 여부를 수신
    let refreshControlCompelted = PublishSubject<Void>() /// 새로고침 완료 여부를 수신

    private let realm = try! Realm()
    private lazy var favorites = realm.objects(Movie.self) /// load realm

    // MARK: - Initializer

    init() {
        bind()
    }

    // MARK: - Helpers

    private func bind() {
        print(realm.configuration.fileURL!)

        favoriteList.accept(favorites.map{$0})

        refreshControlAction
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.refreshControlTriggered()
            }
            .disposed(by: disposeBag)
    }

    /// 새로고침 제어가 트리거되는 즉시, 이전 요청이 취소되고 다시 불러오기
    private func refreshControlTriggered() {
        favoriteList.accept(favorites.map{$0})
        refreshControlCompelted.onNext(()) /// 완료여부 이벤트 전달
    }
}
