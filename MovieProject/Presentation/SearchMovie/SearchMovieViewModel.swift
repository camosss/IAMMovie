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

    let fetchMoreDatas = PublishSubject<Void>()
    let isLoadingSpinnerAvaliable = PublishSubject<Bool>()
    let errorMessage = PublishSubject<Error>()

    var query = ""
    private var startCounter = 1
    private var totalValue = 1
    private let limit = 20

    private let searchMovieAPI: SearchMovieAPIProtocol
    private let disposeBag = DisposeBag()

    // MARK: - Initializer

    init(searchMovieAPI: SearchMovieAPIProtocol = SearchMovieAPI()) {
        self.searchMovieAPI = searchMovieAPI
        bind()
    }

    // MARK: - Helpers

    private func bind() {
        fetchMoreDatas
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.populateMovieList(cursor: self.startCounter)
            }
            .disposed(by: disposeBag)
    }

    private func populateMovieList(cursor: Int) {
        isLoadingSpinnerAvaliable.onNext(true)

        if startCounter > totalValue {
            isLoadingSpinnerAvaliable.onNext(false)
            errorMessage.onNext(NetworkError.last_page)
            return
        }

        if startCounter == 1 {
            isLoadingSpinnerAvaliable.onNext(false)
        }

        searchMovieAPI
            .populateMovieList(query: query, start: cursor)
            .subscribe { [weak self] movies in
                guard let self = self else { return }
                switch movies {
                case .success(let movies):
                    self.handleStartCounter(movies: movies)
                    self.isLoadingSpinnerAvaliable.onNext(false)
                case .failure(let error):
                    self.errorMessage.onNext(error)
                }
            }
            .disposed(by: disposeBag)
    }

    private func handleStartCounter(movies: Movies) {
        totalValue = movies.total

        if startCounter == 1 {
            movieList.accept(movies.items)
        } else {
            let oldDatas = movieList.value
            /// 기존 값을 유지하면서 새로운 값을 accept
            movieList.accept(oldDatas + movies.items)
        }
        startCounter += limit /// 요청
    }

    func searchResultTriggered(query: String) {
        self.query = query
        self.startCounter = 1
        self.movieList.accept([])
        self.fetchMoreDatas.onNext(())
    }
}
