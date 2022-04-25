//
//  SearchMovieViewModel.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/25.
//

import Foundation

import RxCocoa
import RxSwift

final class SearchMovieViewModel {

    // MARK: - Properties

    var movieList = BehaviorRelay<[Movie]>(value: [])

}
