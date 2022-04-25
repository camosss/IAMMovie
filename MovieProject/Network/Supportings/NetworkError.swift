//
//  NetworkError.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/26.
//

import Foundation

enum NetworkError: Int, Error {
    case incorrect_request = 400
    case invalid_search_API = 404
    case system_error = 500
    case last_page
    case unknown_error

    var description: String { self.errorDescription }
}

extension NetworkError {
    var errorDescription: String {
        switch self {
        case .incorrect_request: return "검색 API 요청에 오류가 있습니다."
        case .invalid_search_API: return "검색 결과가 존재하지 않습니다."
        case .system_error: return "서버 내부 에러가 발생하였습니다."
        case .last_page: return "마지막 페이지입니다."
        default: return "알 수 없는 에러가 발생하였습니다."
        }
    }
}
