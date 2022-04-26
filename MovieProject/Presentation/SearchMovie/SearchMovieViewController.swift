//
//  SearchMovieViewController.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/25.
//

import UIKit
import SnapKit
import Toast_Swift

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

        tableView.contentInset.bottom = 50
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(MovieCell.self,
                           forCellReuseIdentifier: MovieCell.reuseIdentifier)
    }

    private func bind() {
        viewModel.movieList
            .asDriver()
            .drive(tableView.rx.items(
                cellIdentifier: MovieCell.reuseIdentifier,
                cellType: MovieCell.self
            )) { index, item, cell in
                cell.configure(movie: item)
            }
            .disposed(by: disposeBag)

        viewModel.errorMessage
            .subscribe(onNext: { error in
                guard let error = error as? NetworkError else { return }
                self.view.makeToast(error.description, position: .center)
            })
            .disposed(by: disposeBag)

        tableView.rx
            .itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.tableView.deselectRow(at: indexPath, animated: false)

                let movie = self.viewModel.movieList.value[indexPath.row]
                let controller = DetailMovieViewController(movie: movie)
                self.navigationController?.pushViewController(controller, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
