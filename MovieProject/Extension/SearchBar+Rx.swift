//
//  SearchBar+Rx.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/27.
//

import UIKit.UISearchBar

import RxCocoa
import RxSwift

extension Reactive where Base: SearchBar {
    var endEditing: Binder<Void> {
        return Binder(base) { base, _ in
            base.endEditing(true)
        }
    }
}
