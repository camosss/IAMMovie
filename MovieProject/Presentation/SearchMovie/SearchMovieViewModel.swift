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
    var errorMessage = PublishSubject<Error>()

    var query: String?
    private var startCounter = 1
    private var limit = 20

    private let searchMovieAPI: SearchMovieAPIProtocol
    private let disposeBag = DisposeBag()

    // MARK: - Initializer

    init(searchMovieAPI: SearchMovieAPIProtocol = SearchMovieAPI()) {
        self.searchMovieAPI = searchMovieAPI
        bind()
    }

    // MARK: - Helpers

    private func bind() {
        searchMovieAPI
            .populateMovieList(query: "test", start: startCounter)
            .subscribe { [weak self] movies in
                guard let self = self else { return }
                switch movies {
                case .success(let movies):
                    self.movieList.accept(movies.items)
                case .failure(let error):
                    self.errorMessage.onNext(error)
                }
            }
            .disposed(by: disposeBag)
    }
}
