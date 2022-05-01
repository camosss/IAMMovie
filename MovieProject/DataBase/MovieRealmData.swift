//
//  MovieRealmData.swift
//  MovieProject
//
//  Created by 강호성 on 2022/05/01.
//

import Foundation

protocol MovieRealmDataProtocol: AnyObject {
    func loadMovie() -> [Movie]
    func saveMovie(movie: Movie?)
    func deleteMovie(movie: Movie?)
}

final class MovieRealmData: MovieRealmDataProtocol {

    var storage: RealmStorage

    init() {
        self.storage = RealmStorage.shared
    }
}

extension MovieRealmData {
    func loadMovie() -> [Movie] {
        let realmDTO = storage.load()
        return realmDTO.map { $0.toDomain() }
    }

    func saveMovie(movie: Movie?) {
        let movieDTO = movie.map { MovieResponseDTO(movie: $0) }
        storage.save(movie: movieDTO)
    }

    func deleteMovie(movie: Movie?) {
        let movieDTO = movie.map { MovieResponseDTO(movie: $0) }
        storage.delete(movie: movieDTO)
    }
}
