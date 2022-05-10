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
    let isLoadingAvaliable = PublishSubject<Bool>() /// 검색, indicator
    let isLoadingSpinnerAvaliable = PublishSubject<Bool>() /// 페이지네이션, footerView indicator
    let errorMessage = PublishSubject<String>()

    var isLoadingRequstStillResume = false /// 로딩 indicator와 emptyView를 구분하기 위한 flag

    var query = "" /// 검색 text
    var startCounter = ParameterValue.start.rawValue /// start (parameter)
    private var totalValue = ParameterValue.start.rawValue /// 전체 결괏값
    private let limit = ParameterValue.display.rawValue /// display (parameter)

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
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.populateMovieList(cursor: owner.startCounter)
            }
            .disposed(by: disposeBag)
    }

    private func populateMovieList(cursor: Int) {
        isLoadingSpinnerAvaliable.onNext(true)

        /// 마지막 페이지
        if startCounter > totalValue {
            isLoadingSpinnerAvaliable.onNext(false)
            errorMessage.onNext(NetworkError.last_page.description)
            return
        }

        /// 처음 페이지
        if startCounter == ParameterValue.start.rawValue {
            isLoadingSpinnerAvaliable.onNext(false)
        }

        searchMovieAPI
            .populateMovieList(query: query, start: cursor)
            .subscribe { [weak self] movies in
                guard let self = self else { return }
                switch movies {
                case .success(let movies):
                    self.handleStartCounter(movies: movies)
                    self.isLoadingAvaliable.onNext(false)
                    self.isLoadingRequstStillResume = false
                    self.isLoadingSpinnerAvaliable.onNext(false)
                case .failure(let error):
                    guard let networkError = error as? NetworkError else { return }
                    self.errorMessage.onNext(networkError.description)
                    self.isLoadingAvaliable.onNext(false)
                    self.isLoadingRequstStillResume = false
                }
            }
            .disposed(by: disposeBag)
    }

    /// 데이터를 TableView에 추가하고 다음 요청에 대한 페이지 정렬
    private func handleStartCounter(movies: Movies) {
        totalValue = movies.total

        if startCounter == ParameterValue.start.rawValue {
            movieList.accept(movies.items)
        } else {
            let oldDatas = movieList.value
            /// 기존 값을 유지하면서 새로운 값을 accept
            movieList.accept(oldDatas + movies.items)
        }
        startCounter += limit /// 요청
    }

    func searchResultTriggered(query: String) {
        self.isLoadingAvaliable.onNext(true)
        self.isLoadingRequstStillResume = true
        self.query = query
        self.startCounter = ParameterValue.start.rawValue
        self.movieList.accept([])
        self.fetchMoreDatas.onNext(())
    }
}
