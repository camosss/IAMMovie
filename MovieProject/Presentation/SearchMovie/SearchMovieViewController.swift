//
//  SearchMovieViewController.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/25.
//

import UIKit
import SnapKit
import Toast

import RxCocoa
import RxSwift

final class SearchMovieViewController: BaseViewController {

    // MARK: - Properties

    private let disposeBag = DisposeBag()
    private let viewModel = SearchMovieViewModel()

    private let searchBar = SearchBar()
    private let tableView = UITableView()
    private let favoritesButton = UIBarButtonItem()

    private lazy var indicator = UIActivityIndicatorView(
        frame: CGRect(x: 0, y: 0, width: 50, height: 50)
    ).then {
        $0.style = UIActivityIndicatorView.Style.medium
        $0.center = view.center
    }

    private lazy var viewSpinner = UIView(
        frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100)
    ).then {
        let spinner = UIActivityIndicatorView()
        spinner.center = $0.center
        $0.addSubview(spinner)
        spinner.startAnimating()
    }

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
        view.addSubview(indicator)
    }

    override func setConstraints() {
        super.setConstraints()
        navigationItem.rightBarButtonItem = favoritesButton

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
        configureLeftBarButtonItem(title: NSLocalizedString(Localization.title.description, comment: ""))

        favoritesButton.image = UIImage(systemName: "star.fill")
        favoritesButton.tintColor = .star

        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = NSLocalizedString(Localization.searchBar.description, comment: "")

        tableView.keyboardDismissMode = .onDrag
        tableView.contentInset.bottom = 50
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(MovieCell.self,
                           forCellReuseIdentifier: MovieCell.reuseIdentifier)
    }

    private func bind() {
        tableViewBind()

        /// 페이지네이션, footerView indicator
        viewModel.isLoadingSpinnerAvaliable
            .withUnretained(self)
            .subscribe { owner, isAvailable in
                owner.tableView.tableFooterView = isAvailable ? owner.viewSpinner : UIView(frame: .zero)
            }
            .disposed(by: disposeBag)

        /// [Toast] Error Message
        viewModel.errorMessage
            .withUnretained(self)
            .subscribe(onNext: { owner, error in
                owner.makeToastMessage(message: error)
            })
            .disposed(by: disposeBag)

        /// 검색 이벤트
        searchBar.shouldLoadResult
            .asSignal(onErrorJustReturn: "")
            .withUnretained(self)
            .emit(onNext: { owner, query in
                owner.viewModel.searchResultTriggered(query: query)
            })
            .disposed(by: disposeBag)

        /// 검색, indicator
        viewModel.isLoadingAvaliable
            .withUnretained(self)
            .subscribe { owner, isAvailable in
                if isAvailable {
                    owner.indicator.startAnimating()
                } else {
                    owner.indicator.stopAnimating()
                }
            }
            .disposed(by: disposeBag)

        favoritesButton.rx.tap
            .bind {
                let controller = FavoritesViewController()
                self.navigationController?.pushViewController(controller, animated: true)
            }
            .disposed(by: disposeBag)
    }

    private func tableViewBind() {
        /// 검색 결괏값 0일 때, EmptyView
        viewModel.movieList
            .map { return $0.count <= 0 && !self.viewModel.isLoadingRequstStillResume }
            .bind(to: tableView.rx.isEmpty(
                title: NSLocalizedString(Localization.empty_Search.description, comment: ""),
                imageName: "film")
            )
            .disposed(by: disposeBag)

        /// tableView dataSource
        viewModel.movieList
            .asDriver()
            .drive(tableView.rx.items(
                cellIdentifier: MovieCell.reuseIdentifier,
                cellType: MovieCell.self
            )) { index, item, cell in
                cell.configure(movie: item)
            }
            .disposed(by: disposeBag)

        /// DetailView로 전환
        tableView.rx
            .itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                owner.tableView.deselectRow(at: indexPath, animated: false)

                let movie = self.viewModel.movieList.value[indexPath.row]
                let controller = DetailMovieViewController(movie: movie)
                owner.navigationController?.pushViewController(controller, animated: true)
            })
            .disposed(by: disposeBag)

        /// 페이지네이션
        tableView.rx
            .didScroll
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe { owner, _ in
                let offSetY = owner.tableView.contentOffset.y /// 현재 스크롤된 위치
                let contentHeight = owner.tableView.contentSize.height /// 전체 content 높이

                if offSetY > (contentHeight - owner.tableView.frame.size.height - 100) {
                    if owner.viewModel.startCounter > 1 {
                        owner.viewModel.fetchMoreDatas.onNext(())
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}
