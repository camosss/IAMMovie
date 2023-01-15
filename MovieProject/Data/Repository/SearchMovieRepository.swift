//
//  SearchMovieRepository.swift
//  MovieProject
//
//  Created by 강호성 on 2023/01/09.
//

import Foundation

import Moya
import RxCocoa
import RxSwift

final class SearchMovieRepository: SearchMovieType {
    let provider: MoyaProvider<SearchMovieTarget>
    init() { provider = MoyaProvider<SearchMovieTarget>() }
}

extension SearchMovieRepository {
    /// 영화 데이터 불러오기
    func requestMovieResponse(
        query: String,
        start: Int,
        completion: @escaping (Result<Movies, NetworkError>) -> Void
    ) {
        provider.request(.populateMovieList(
            query: query,
            start: start
        )) { result in
            switch result {
            case .success(let value):
                do {
                    let response = try value.map(MoviesResponseDTO.self)
                    if response.total == 0 {
                        completion(.failure(NetworkError.invalid_search_API))
                    } else {
                        completion(.success(response.toDomain()))
                    }
                } catch {
                    switch value.statusCode {
                    case NetworkError.incorrect_request.rawValue:
                        completion(.failure(NetworkError.incorrect_request))
                    case NetworkError.invalid_search_API.rawValue:
                        completion(.failure(NetworkError.invalid_search_API))
                    case NetworkError.system_error.rawValue:
                        completion(.failure(NetworkError.system_error))
                    default:
                        completion(.failure(NetworkError.unknown_error))
                    }
                }
            case .failure:
                completion(.failure(NetworkError.unknown_error))
            }
        }
    }
}

