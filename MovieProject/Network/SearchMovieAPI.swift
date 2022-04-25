//
//  SearchMovieAPI.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/25.
//

import RxSwift
import Moya

protocol SearchMovieAPIProtocol {
    func populateMovieList(query: String) -> Single<[Movie]>
}

final class SearchMovieAPI: SearchMovieAPIProtocol {
    let service: MoyaProvider<SearchMovieTarget>
    init() { service = MoyaProvider<SearchMovieTarget>() }
}

extension SearchMovieAPI {
    func populateMovieList(query: String) -> Single<[Movie]> {
        return Single.create() { single in
            self.service
                .request(.populateMovieList(query: query)) { result in
                    switch result {
                    case .success(let value):
                        do {
                            let response = try value.map([Movie].self)
                            single(.success(response))
                        } catch {
                            switch value.statusCode {
                            default: single(.failure(error))
                            }
                        }
                    case .failure(let error):
                        single(.failure(error))
                    }
                }
            return Disposables.create()
        }
    }
}
