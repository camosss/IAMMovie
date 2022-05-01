//
//  MovieResponseDTO.swift
//  MovieProject
//
//  Created by 강호성 on 2022/05/01.
//

import RealmSwift

class MovieResponseDTO: Object {
    @Persisted var title: String
    @Persisted var link: String
    @Persisted var image: String
    @Persisted var subtitle: String
    @Persisted var pubDate: String
    @Persisted var director: String
    @Persisted var actor: String
    @Persisted var userRating: String

    override class func primaryKey() -> String? {
        return "link"
    }

    convenience init(movie: Movie) {
        self.init()
        self.title = movie.title
            .replacingOccurrences(of: "</b>", with: "")
            .replacingOccurrences(of: "<b>", with: "")
        self.link = movie.link
        self.image = movie.image
        self.subtitle = movie.subtitle
        self.pubDate = movie.pubDate
        self.director = movie.director
        self.actor = movie.actor
        self.userRating = movie.userRating
    }
}

extension MovieResponseDTO {
    func toDomain() -> Movie {
        return .init(title: title,
                     link: link,
                     image: image,
                     subtitle: subtitle,
                     pubDate: pubDate,
                     director: director,
                     actor: actor,
                     userRating: userRating)
    }
}
