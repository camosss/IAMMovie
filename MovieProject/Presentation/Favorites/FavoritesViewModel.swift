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
    }
}
