//
//  SearchMovieType.swift
//  MovieProject
//
//  Created by 강호성 on 2023/01/09.
//

import Foundation

protocol SearchMovieType {
    /// 영화 데이터 불러오기
    func requestMovieResponse(
        query: String,  /// 검색어
        start: Int,     /// 페이지
        completion: @escaping (Result<Movies, NetworkError>) -> Void
    )
}
