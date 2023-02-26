//
//  SearchViewController.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/25.
//

import UIKit
import SnapKit
import Toast

import RxCocoa
import RxSwift

final class SearchViewController: BaseViewController {

    // MARK: - Properties

    private let searchBar = SearchBar()
    private let tableView = UITableView()
    private let favoritesButton = UIBarButtonItem()
    private let languageButton = UIBarButtonItem()

    private let requestNextPage = PublishRelay<Int>()

    private lazy var input = SearchViewModel.Input(
        searchBarText: searchBar.shouldLoadResult.asSignal(onErrorJustReturn: ""),
        requestNextPage: requestNextPage.asSignal(),
        favoritesButtonDidTap: favoritesButton.rx.tap.asSignal(),
        languageButtonDidTap: languageButton.rx.tap.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    private let viewModel: SearchViewModel

    // MARK: - Lifecycle

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        navigationItem.rightBarButtonItems = [languageButton, favoritesButton]

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
        configureLeftBarButtonItem(title: Localization.title.description.localized)

        languageButton.image = UIImage(systemName: "globe.asia.australia")
        favoritesButton.image = UIImage(systemName: "star.fill")
        favoritesButton.tintColor = .star

        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = Localization.searchBar.description.localized

        tableView.keyboardDismissMode = .onDrag
        tableView.contentInset.bottom = 50
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(MovieTableViewCell.self,
                           forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier)
    }
}

// MARK: - Bind
extension SearchViewController {
    private func bind() {
        /// 검색 결괏값 0일 때, EmptyView
        output.movieList
            .map { return $0.count <= 0}
            .drive(tableView.rx.isEmpty(
                title: Localization.empty_Search.description.localized,
                imageName: "film")
            )
            .disposed(by: disposeBag)

        /// tableView dataSource
        output.movieList
            .asDriver()
            .drive(tableView.rx.items(
                cellIdentifier: MovieTableViewCell.reuseIdentifier,
                cellType: MovieTableViewCell.self
            )) { index, item, cell in
                cell.configure(movie: item)
            }
            .disposed(by: disposeBag)

        /// 페이지네이션
        tableView.rx.willDisplayCell
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _, indexPath in
                guard let self = self else { return }
                self.requestNextPage.accept(indexPath.row)
            })
            .disposed(by: disposeBag)

        /// DetailView로 전환
        tableView.rx
            .itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                owner.tableView.deselectRow(at: indexPath, animated: false)

//                let movie = self.viewModel.movieList.value[indexPath.row]
//                let controller = DetailMovieViewController(movie: movie)
//                owner.navigationController?.pushViewController(controller, animated: true)
            })
            .disposed(by: disposeBag)

        output.isLanguageState
            .emit(onNext: { [weak self] _ in
                guard let self = self else { return }
                Alert.actionSheetAlert(
                    title: Localization.alert_Title.description.localization(),
                    cancel: Localization.alert_Cancel.description.localization(),
                    first: "English",
                    second: "한국어",
                    third: "日本語",
                    onFirst: {
                        self.populateLanguage("en")
                    }, onSecond: {
                        self.populateLanguage("ko")
                    }, onThird: {
                        self.populateLanguage("ja")
                    }, over: self)
            })
            .disposed(by: disposeBag)

        /// tableView isEmpty를 바인딩하고 있기 때문에, View 교체하기 위함 (검색 로딩, 페이지네이션)
        output.isLoadingAvaliable
            .emit(to: tableView.rx.isLoading())
            .disposed(by: disposeBag)

        output.isLoadingSpinnerAvaliable
            .emit(to: tableView.rx.isBottomSpinner())
            .disposed(by: disposeBag)
    }
}

extension SearchViewController {
    private func populateLanguage(_ lang: String) {
        UserDefaults.standard.set([lang], forKey: "language")

        configureLeftBarButtonItem(title: Localization.title.description.localization())
        searchBar.placeholder = Localization.searchBar.description.localization()

        viewModel.movieList
            .map { return $0.count <= 0 }
            .bind(to: tableView.rx.isEmpty(
                title: Localization.empty_Search.description.localization(),
                imageName: "film")
            )
            .disposed(by: disposeBag)
    }
}
