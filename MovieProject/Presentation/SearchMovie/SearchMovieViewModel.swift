//
//  SearchMovieViewModel.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/25.
//

import Foundation

import RxCocoa
import RxSwift

final class SearchMovieViewModel {

    // MARK: - Properties

    var movieList = BehaviorRelay<[MovieList]>(value: [MovieList(title: "titletitletitletitletitletitletitletitletitletitletitletitle", link: "link", imageURL: "", pubDate: "pubDate", director: "director", actors: "actors", userRating: "userRating"), MovieList(title: "title", link: "link", imageURL: "", pubDate: "pubDate", director: "director", actors: "actorsactorsactorsactorsactorsactorsactorsactors", userRating: "userRating"), MovieList(title: "titletitletitletitletitletitletitletitletitletitletitletitletitletitletitletitletitletitle", link: "link", imageURL: "", pubDate: "pubDate", director: "director", actors: "actors", userRating: "userRating")])
}
