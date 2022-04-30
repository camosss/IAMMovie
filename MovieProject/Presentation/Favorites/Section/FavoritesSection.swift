//
//  FavoritesSection.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/30.
//

import Foundation
import RxDataSources

typealias MoviesItems = [Movie]

struct FavoritesSection {

    typealias FavoritesSectionModel = SectionModel<Int, MoviesItems>

    enum MoviesItems: Equatable {
        case firstItem(Movie)
    }
}
