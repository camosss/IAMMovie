//
//  SearchViewModel.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/25.
//

import Foundation
import ProgressHUD

import RxCocoa
import RxSwift

final class SearchViewModel: ViewModelType {

    private weak var coordinator: MainCoordinator?
    private let useCase: SearchUseCase
    
    struct Input {
        let searchBarText: Signal<String>
    }
    struct Output {
        let movieList: Driver<[Movie]>
    }
    var disposeBag = DisposeBag()
    
    // MARK: - Properties
    
    private let movieList = BehaviorRelay<[Movie]>(value: [])

    private var query = "" /// 검색 text
    private var startCounter = ParameterValue.start.rawValue /// start (parameter)
    private let limitCounter = ParameterValue.display.rawValue /// display (parameter)


    let fetchMoreDatas = PublishRelay<Void>()
    let isLoadingAvaliable = PublishRelay<Bool>() /// 검색, indicator
    let isLoadingSpinnerAvaliable = PublishRelay<Bool>() /// 페이지네이션, footerView indicator
    let errorMessage = PublishRelay<String>()
    
    var isLoadingRequstStillResume = false /// 로딩 indicator와 emptyView를 구분하기 위한 flag
    
//    var query = "" /// 검색 text
//    var startCounter = ParameterValue.start.rawValue /// start (parameter)
    private var totalValue = ParameterValue.start.rawValue /// 전체 결괏값
//    private let limitCounter = ParameterValue.display.rawValue /// display (parameter)
    
//    private let searchMovieAPI: SearchMovieAPIProtocol
    
    // MARK: - Initializer
    
    init(coordinator: MainCoordinator?, useCase: SearchUseCase) {
        self.coordinator = coordinator
        self.useCase = useCase
    }

    // MARK: - Helpers

    func transform(input: Input) -> Output {
        input.searchBarText
            .emit(onNext: { [weak self] query in
                guard let self = self else { return }
                self.useCase.requestMovieResponse(query: query, start: self.startCounter)
            })
            .disposed(by: disposeBag)

        useCase.movieResultSignal
            .asSignal()
            .emit(onNext: { [weak self] list in
                guard let self = self else { return }
                self.movieList.accept(list.items)
                print(list)
            })
            .disposed(by: disposeBag)

        useCase.failError
            .asSignal()
            .do { error in
                ProgressHUD.show(error.description, icon: .failed, interaction: false)
            }
            .map { _ in [] }
            .emit(to: movieList)
            .disposed(by: disposeBag)

        return Output(
            movieList: movieList.asDriver()
        )
    }

//    private func bind() {
//        fetchMoreDatas
//            .withUnretained(self)
//            .subscribe { owner, _ in
//                owner.populateMovieList(cursor: owner.startCounter)
//            }
//            .disposed(by: disposeBag)
//    }
//
//    private func populateMovieList(cursor: Int) {
//        isLoadingSpinnerAvaliable.accept(true)
//
//        /// 마지막 페이지
//        if startCounter > totalValue {
//            isLoadingSpinnerAvaliable.accept(false)
//            errorMessage.accept(NetworkError.last_page.description)
//            return
//        }
//
//        /// 처음 페이지
//        if startCounter == ParameterValue.start.rawValue {
//            isLoadingSpinnerAvaliable.accept(false)
//        }
//
//        searchMovieAPI
//            .populateMovieList(query: query, start: cursor)
//            .subscribe { [weak self] movies in
//                guard let self = self else { return }
//                switch movies {
//                case .success(let movies):
//                    self.handleStartCounter(movies: movies)
//                    self.isLoadingAvaliable.accept(false)
//                    self.isLoadingRequstStillResume = false
//                    self.isLoadingSpinnerAvaliable.accept(false)
//                case .failure(let error):
//                    guard let networkError = error as? NetworkError else { return }
//                    self.errorMessage.accept(networkError.description)
//                    self.isLoadingAvaliable.accept(false)
//                    self.isLoadingRequstStillResume = false
//                }
//            }
//            .disposed(by: disposeBag)
//    }

//    /// 데이터를 TableView에 추가하고 다음 요청에 대한 페이지 정렬
//    private func handleStartCounter(movies: Movies) {
//        totalValue = movies.total
//
//        if startCounter == ParameterValue.start.rawValue {
//            movieList.accept(movies.items)
//        } else {
//            let oldDatas = movieList.value
//            /// 기존 값을 유지하면서 새로운 값을 accept
//            movieList.accept(oldDatas + movies.items)
//        }
//        startCounter += limitCounter /// 요청
//    }
//
//    func searchResultTriggered(query: String) {
//        self.isLoadingAvaliable.accept(true)
//        self.isLoadingRequstStillResume = true
//        self.query = query
//        self.startCounter = ParameterValue.start.rawValue
//        self.movieList.accept([])
//        self.fetchMoreDatas.accept(())
//    }
}
