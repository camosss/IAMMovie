//
//  FavoritesViewController.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/27.
//

import UIKit

import RxCocoa
import RxSwift

final class FavoritesViewController: BaseViewController {

    // MARK: - Properties

    private let disposeBag = DisposeBag()
    private let viewModel = FavoritesViewModel()

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    // MARK: - Helpers

    override func setViews() {
        super.setViews()
        view.addSubview(tableView)
    }

    override func setConstraints() {
        super.setConstraints()
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func setConfigurations() {
        super.setConfigurations()
        title = "즐겨찾기 목록"

        tableView.register(MovieCell.self,
                           forCellReuseIdentifier: MovieCell.reuseIdentifier)
    }

    private func bind() {
        viewModel.favoriteList
            .map { return $0.count <= 0 }
            .bind(to: tableView.rx.isEmpty(
                title: "즐겨찾기 목록이 비었습니다.",
                imageName: "scribble.variable"
            ))
            .disposed(by: disposeBag)

        viewModel.favoriteList
            .asDriver()
            .drive(tableView.rx.items(
                cellIdentifier: MovieCell.reuseIdentifier,
                cellType: MovieCell.self
            )) { index, item, cell in
                cell.configure(movie: item)
            }
            .disposed(by: disposeBag)
    }
}
