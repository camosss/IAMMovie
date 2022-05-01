//
//  RealmStorage.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/30.
//

import Foundation
import RealmSwift

final class RealmStorage {

    static let shared = RealmStorage()
    private let realm = try! Realm()

    func load() -> Results<MovieResponseDTO> {
        let loadMovie = realm.objects(MovieResponseDTO.self)
        return loadMovie
    }

    func save(movie: MovieResponseDTO?) {
        try! realm.write {
            /// realm 객체에 Json을 전달하는 대신 객체를 먼저 복사한 후 복제된 객체를 저장
            let copyMovie = self.realm.create(MovieResponseDTO.self, value: movie!, update: .all)
            realm.add(copyMovie)
        }
    }

    func delete(movie: MovieResponseDTO?) {
        try! realm.write {
            /// realm 객체에 Json을 전달하는 대신 객체를 먼저 복사한 후 복제된 객체를 삭제
            let copyMovie = self.realm.create(MovieResponseDTO.self, value: movie!, update: .all)
            realm.delete(copyMovie)
        }
    }
}
