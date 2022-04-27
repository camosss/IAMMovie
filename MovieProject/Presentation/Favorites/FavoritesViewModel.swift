//
//  FavoritesViewModel.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/27.
//

import Foundation

import RxCocoa
import RxSwift

final class FavoritesViewModel {

    // MARK: - Properties

    var favoriteList = BehaviorRelay<[Movie]>(value: [Movie(title: "제목", link: "", image: "https://ssl.pstatic.net/imgmovie/mdi/mit110/1873/187347_P01_103714.jpg", subtitle: "", pubDate: "", director: "감독", actor: "배우", userRating: "9.0"), Movie(title: "제목", link: "", image: "https://ssl.pstatic.net/imgmovie/mdi/mit110/1873/187347_P01_103714.jpg", subtitle: "", pubDate: "", director: "감독", actor: "배우", userRating: "9.0")])

}
