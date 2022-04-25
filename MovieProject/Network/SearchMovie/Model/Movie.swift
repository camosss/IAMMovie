//
//  Movie.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/25.
//

import UIKit

struct Movies: Codable {
    let lastBuildDate: String
    let total, start, display: Int
    let items: [Movie]
}

struct Movie: Codable {
    let title: String?
    let link: String?
    let image: String?
    let subtitle: String?
    let pubDate: String?
    let director: String?
    let actor: String?
    let userRating: String?
}
