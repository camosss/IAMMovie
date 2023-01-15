//
//  SearchMovieUseCase.swift
//  MovieProject
//
//  Created by 강호성 on 2023/01/15.
//

import Foundation

import RxCocoa
import RxSwift

final class SearchMovieUseCase {

    // MARK: - Properties

    private let repository: SearchMovieRepository

    var movieResultSignal = PublishRelay<Movies>()
    var failError = PublishRelay<NetworkError>()

    // MARK: - Init

    init(repository: SearchMovieRepository) {
        self.repository = repository
    }

    // MARK: - Helpers

    func requestMovieResponse(query: String, start: Int) {
        repository.requestMovieResponse(
            query: query,
            start: start
        ) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let value):
                self.movieResultSignal.accept(value)
            case .failure(let error):
                self.failError.accept(error)
            }
        }
    }

}
