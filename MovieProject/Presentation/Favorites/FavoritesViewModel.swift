//
//  FavoritesViewModel.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/27.
//

import Foundation

import RxCocoa
import RxSwift

final class FavoritesViewModel {

    // MARK: - Properties

    var favoriteList = BehaviorRelay<[Movie]>(value: [])

}
