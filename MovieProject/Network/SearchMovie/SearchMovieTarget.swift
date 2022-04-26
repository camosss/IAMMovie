//
//  SearchMovieTarget.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/25.
//

import Moya

enum SearchMovieTarget {
    case populateMovieList(query: String, start: Int)
}

extension SearchMovieTarget: TargetType {
    var baseURL: URL {
        return URL(string: "https://openapi.naver.com/v1")!
    }

    var path: String {
        switch self {
        case .populateMovieList:
            return "/search/movie.json"
        }
    }

    var method: Method {
        switch self {
        case .populateMovieList:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .populateMovieList(let query, let start):
            return .requestParameters(
                parameters: ["query": query,
                             "start": start,
                             "display": 20],
                encoding: URLEncoding.default
            )
        }
    }

    var headers: [String : String]? {
        switch self {
        case .populateMovieList:
            return ["X-Naver-Client-Id": ClientKey.clientID,
                    "X-Naver-Client-Secret": ClientKey.clientSecret]
        }
    }
}
