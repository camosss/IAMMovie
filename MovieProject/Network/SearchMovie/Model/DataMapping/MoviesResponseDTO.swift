//
//  MoviesResponseDTO.swift
//  MovieProject
//
//  Created by 강호성 on 2022/05/01.
//

import UIKit

// MARK: - MoviesResponseDTO

struct MoviesResponseDTO: Decodable {
    var lastBuildDate: String
    var total, start, display: Int
    var items: [MovieDTO]
}

extension MoviesResponseDTO {
    func toDomain() -> Movies {
        return .init(lastBuildDate: lastBuildDate,
                     total: total,
                     start: start,
                     display: display,
                     items: items.map { $0.toDomain() })
    }
}

// MARK: - MovieDTO

struct MovieDTO: Decodable {
    var title: String
    var link: String
    var image: String
    var subtitle: String
    var pubDate: String
    var director: String
    var actor: String
    var userRating: String
}

extension MovieDTO {
    func toDomain() -> Movie {
        return .init(title: title.replacing(data: title),
                     link: link,
                     image: image,
                     subtitle: subtitle,
                     pubDate: pubDate,
                     director: director.trimmingAndReplacing(data: director),
                     actor: actor.trimmingAndReplacing(data: actor),
                     userRating: userRating)
    }
}
