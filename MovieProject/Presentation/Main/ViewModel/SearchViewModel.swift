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

    // MARK: - Properties

    private weak var coordinator: MainCoordinator?
    private let useCase: SearchUseCase
    
    struct Input {
        let searchBarText: Signal<String>
        let requestNextPage: Signal<Int>
        let favoritesButtonDidTap: Signal<Void>
        let languageButtonDidTap: Signal<Void>
    }
    struct Output {
        let movieList: Driver<[Movie]>
        let isLoadingAvaliable: Signal<Bool>
        let isLoadingSpinnerAvaliable: Signal<Bool>
        let isLanguageState: Signal<Void>
    }
    var disposeBag = DisposeBag()

    let movieList = BehaviorRelay<[Movie]>(value: [])
    private let isLoadingAvaliable = PublishRelay<Bool>() /// 검색, indicator
    private let isLoadingSpinnerAvaliable = PublishRelay<Bool>() /// 페이지네이션, footerView indicator
    private let isLanguageState = PublishRelay<Void>()

    private var query = "" /// 검색 text
    private var startCounter = ParameterValue.start.rawValue /// start (parameter)
    private let limitCounter = ParameterValue.display.rawValue /// display (parameter)
    private var totalValue = ParameterValue.start.rawValue /// 전체 결괏값

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

                self.query = query
                self.startCounter = ParameterValue.start.rawValue
                self.movieList.accept([])
                self.isLoadingAvaliable.accept(true)

                /// 호출
                self.useCase.requestMovieResponse(
                    query: self.query,
                    start: self.startCounter
                )
            })
            .disposed(by: disposeBag)

        input.requestNextPage
            .emit(onNext: { [weak self] index in
                guard let self = self else { return }

                if self.startCounter > 1,
                   self.movieList.value.count - 10 == index,
                   self.totalValue > self.movieList.value.count {

                    self.isLoadingSpinnerAvaliable.accept(true)
                    self.useCase.requestMovieResponse(
                        query: self.query,
                        start: self.startCounter
                    )
                }
            })
            .disposed(by: disposeBag)

        input.favoritesButtonDidTap
            .emit(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.coordinator?.showFavoriteViewController()
            })
            .disposed(by: disposeBag)

        input.languageButtonDidTap
            .emit(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.isLanguageState.accept(())
            })
            .disposed(by: disposeBag)

        useCase.movieResult
            .asSignal()
            .emit(onNext: { [weak self] list in
                guard let self = self else { return }

                self.totalValue = list.total
                self.isLoadingAvaliable.accept(false)
                self.isLoadingSpinnerAvaliable.accept(false)

                if self.startCounter == ParameterValue.start.rawValue {
                    self.movieList.accept(list.items)
                } else {
                    let oldDatas = self.movieList.value
                    self.movieList.accept(oldDatas + list.items)
                }
                self.startCounter += self.limitCounter
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
            movieList: movieList.asDriver(),
            isLoadingAvaliable: isLoadingAvaliable.asSignal(),
            isLoadingSpinnerAvaliable: isLoadingSpinnerAvaliable.asSignal(),
            isLanguageState: isLanguageState.asSignal()
        )
    }
}
