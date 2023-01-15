//
//  StarStatus.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/29.
//

import Foundation

enum StarStatus {
    case star
    case unstar

    var description: String { self.starDescription }
}

extension StarStatus {
    var starDescription: String {
        switch self {
        case .star: return "즐겨찾기에 추가했어요"
        case .unstar: return "즐겨찾기에서 삭제했어요"
        }
    }
}
