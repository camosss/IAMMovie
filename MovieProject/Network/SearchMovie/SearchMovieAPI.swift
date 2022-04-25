//
//  SearchMovieAPI.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/25.
//

import RxSwift
import Moya

protocol SearchMovieAPIProtocol {
    func populateMovieList(query: String, start: Int) -> Single<Movies>
}

final class SearchMovieAPI: SearchMovieAPIProtocol {
    let service: MoyaProvider<SearchMovieTarget>
    init() { service = MoyaProvider<SearchMovieTarget>() }
}

extension SearchMovieAPI {
    func populateMovieList(query: String, start: Int) -> Single<Movies> {
        return Single.create() { single in
            self.service
                .request(.populateMovieList(query: query, start: start)) { result in
                    switch result {
                    case .success(let value):
                        do {
                            let response = try value.map(Movies.self)
                            single(.success(response))
                        } catch {
                            switch value.statusCode {
                            case 400: single(.failure(NetworkError.incorrect_request))
                            case 404: single(.failure(NetworkError.invalid_search_API))
                            case 500: single(.failure(NetworkError.system_error))
                            default: single(.failure(NetworkError.unknown_error))
                            }
                        }
                    case .failure:
                        single(.failure(NetworkError.unknown_error))
                    }
                }
            return Disposables.create()
        }
    }
}
