//
//  SearchUseCase.swift
//  MovieProject
//
//  Created by 강호성 on 2023/01/15.
//

import Foundation

import RxCocoa
import RxSwift

final class SearchUseCase {

    // MARK: - Properties

    private let repository: SearchRepository

    var movieResult = PublishRelay<Movies>()
    var failError = PublishRelay<NetworkError>()

    // MARK: - Init

    init(repository: SearchRepository) {
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
                self.movieResult.accept(value)
            case .failure(let error):
                self.failError.accept(error)
            }
        }
    }

}
