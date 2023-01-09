//
//  Localization.swift
//  MovieProject
//
//  Created by 강호성 on 2022/05/20.
//

import Foundation

enum Localization {
    case title
    case searchBar
    case empty_Search
    case favorites
    case empty_Favorites
    case alert_Title
    case alert_Cancel

    var description: String { self.localizableDescription }
}

extension Localization {
    var localizableDescription: String {
        switch self {
        case .title: return "Title"
        case .searchBar: return "SearchBar"
        case .empty_Search: return "Empty_Search"
        case .favorites: return "Favorites"
        case .empty_Favorites: return "Empty_Favorites"
        case .alert_Title: return "Alert_Title"
        case .alert_Cancel: return "Alert_Cancel"
        }
    }
}
