//
//  Movie.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/25.
//

import UIKit
import RealmSwift

struct Movies: Codable {
    var lastBuildDate: String
    var total, start, display: Int
    var items: [Movie]
}

struct Movie: Codable {
    var title: String
    var link: String
    var image: String
    var subtitle: String
    var pubDate: String
    var director: String
    var actor: String
    var userRating: String
}

extension Movie: Equatable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.link == rhs.link
    }
}
