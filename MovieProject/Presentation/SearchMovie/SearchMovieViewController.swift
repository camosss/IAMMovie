//
//  SearchMovieViewController.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/25.
//

import UIKit
import SnapKit

import RxCocoa
import RxSwift

final class SearchMovieViewController: BaseViewController {

    // MARK: - Properties

    private let disposeBag = DisposeBag()
    private let viewModel = SearchMovieViewModel()

    private let searchBar = UISearchBar()
    private let tableView = UITableView()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    // MARK: - Helpers

    override func setViews() {
        super.setViews()
        view.addSubview(searchBar)
        view.addSubview(tableView)
    }

    override func setConstraints() {
        super.setConstraints()
        searchBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    override func setConfigurations() {
        super.setConfigurations()
        configureLeftBarButtonItem(title: "네이버 영화 검색")

        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = "영화를 검색해주세요..."

        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(SearchMovieCell.self,
                           forCellReuseIdentifier: SearchMovieCell.reuseIdentifier)
    }

    private func bind() {
        viewModel.movieList
            .asDriver()
            .drive(tableView.rx.items(
                cellIdentifier: SearchMovieCell.reuseIdentifier,
                cellType: SearchMovieCell.self
            )) { index, item, cell in
                cell.configure(movie: item)
            }
            .disposed(by: disposeBag)
    }
}
