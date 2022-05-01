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
    private init() {}

    private let realm = try! Realm()

    func load() -> Results<MovieRealmDTO> {
        let loadMovie = realm.objects(MovieRealmDTO.self)
        return loadMovie
    }

    func save(movie: MovieRealmDTO?) {
        try! realm.write {
            /// 객체를 먼저 복사한 후 realm에 복제된 객체를 저장
            let copyMovie = self.realm.create(MovieRealmDTO.self, value: movie!, update: .all)
            realm.add(copyMovie)
        }
    }

    func delete(movie: MovieRealmDTO?) {
        try! realm.write {
            /// 객체를 먼저 복사한 후 realm에 복제된 객체를 삭제
            let copyMovie = self.realm.create(MovieRealmDTO.self, value: movie!, update: .all)
            realm.delete(copyMovie)
        }
    }
}
