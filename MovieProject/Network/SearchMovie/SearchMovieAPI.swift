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
                            let response = try value.map(MoviesResponseDTO.self)
                            if response.total == 0 {
                                single(.failure(NetworkError.invalid_search_API))
                            } else {
                                single(.success(response.toDomain()))
                            }
                        } catch {
                            switch value.statusCode {
                            case NetworkError.incorrect_request.rawValue:
                                single(.failure(NetworkError.incorrect_request))
                            case NetworkError.invalid_search_API.rawValue:
                                single(.failure(NetworkError.invalid_search_API))
                            case NetworkError.system_error.rawValue:
                                single(.failure(NetworkError.system_error))
                            default:
                                single(.failure(NetworkError.unknown_error))
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
