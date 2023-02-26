//
//  UITableView+Rx.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/27.
//

import UIKit

import RxCocoa
import RxSwift

extension Reactive where Base: UITableView {
    func isEmpty(title: String, imageName: String) -> Binder<Bool> {
        return Binder(base) { tableView, isEmpty in
            if isEmpty {
                tableView.setEmptyView(title: title, imageName: imageName)
            } else {
                tableView.removeBackgroundView()
            }
        }
    }

    func isLoading() -> Binder<Bool> {
        return Binder(base) { tableView, isLoading in
            if isLoading {
                tableView.setLoadingView()
            } else {
                tableView.removeBackgroundView()
            }
        }
    }

    func isBottomSpinner() -> Binder<Bool> {
        return Binder(base) { tableView, isEmpty in
            if isEmpty {
                tableView.setBottomSpinner()
            } else {
                tableView.removeSpinnerFooter()
            }
        }
    }
}
