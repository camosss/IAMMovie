//
//  Movie.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/25.
//

import UIKit
import RealmSwift

class Movies: Codable {
    var lastBuildDate: String
    var total, start, display: Int
    var items = List<Movie>()

    var itemArray: [Movie] {
        get {
            return items.map{$0}
        }
        set {
            items.removeAll()
            items.append(objectsIn: newValue)
        }
    }
}

class Movie: Object, Codable {
    @Persisted var title: String?
    @Persisted var link: String?
    @Persisted var image: String?
    @Persisted var subtitle: String?
    @Persisted var pubDate: String?
    @Persisted var director: String?
    @Persisted var actor: String?
    @Persisted var userRating: String?

    override class func primaryKey() -> String? {
        return "link"
    }
}
