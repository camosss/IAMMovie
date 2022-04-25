//
//  SearchMovieTarget.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/25.
//

import Moya

enum SearchMovieTarget {
    case populateMovieList(query: String)
}

extension SearchMovieTarget: TargetType {
    var baseURL: URL {
        return URL(string: "https://openapi.naver.com/v1")!
    }

    var path: String {
        switch self {
        case .populateMovieList(let query):
            return "/search/movie.xml?query=\(query)"
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
        case .populateMovieList:
            return .requestPlain
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
