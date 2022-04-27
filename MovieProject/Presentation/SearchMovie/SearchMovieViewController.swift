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

    private let searchBar = SearchBar()
    private let tableView = UITableView()

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
        searchBar.placeholder = "영화를 검색해주세요.."

        tableView.keyboardDismissMode = .onDrag
        tableView.contentInset.bottom = 50
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(MovieCell.self,
                           forCellReuseIdentifier: MovieCell.reuseIdentifier)
    }

    private func bind() {
        tableViewBind()

        viewModel.isLoadingSpinnerAvaliable
            .subscribe { [weak self] isAvailable in
                guard let isAvailable = isAvailable.element,
                      let self = self else { return }
                self.tableView.tableFooterView = isAvailable ? self.viewSpinner : UIView(frame: .zero)
            }
            .disposed(by: disposeBag)

        viewModel.errorMessage
            .subscribe(onNext: { error in
                guard let error = error as? NetworkError else { return }
                self.view.makeToast(error.description, position: .center)
            })
            .disposed(by: disposeBag)

        searchBar.shouldLoadResult
            .asSignal(onErrorJustReturn: "")
            .emit(onNext: { [weak self] query in
                guard let self = self else { return }
                self.viewModel.searchResultTriggered(query: query)
            })
            .disposed(by: disposeBag)

        viewModel.isLoadingAvaliable
            .subscribe { [weak self] isAvailable in
                guard let isAvailable = isAvailable.element,
                      let self = self else { return }
                if isAvailable {
                    self.indicator.startAnimating()
                } else {
                    self.indicator.stopAnimating()
                }
            }
            .disposed(by: disposeBag)
    }

    private func tableViewBind() {
        viewModel.movieList
            .map { return $0.count <= 0 }
            .bind(to: tableView.rx.isEmpty(
                title: "영화를 검색해보세요!",
                imageName: "film")
            )
            .disposed(by: disposeBag)

        viewModel.movieList
            .asDriver()
            .drive(tableView.rx.items(
                cellIdentifier: MovieCell.reuseIdentifier,
                cellType: MovieCell.self
            )) { index, item, cell in
                cell.configure(movie: item)
            }
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

        tableView.rx
            .didScroll
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                let offSetY = self.tableView.contentOffset.y /// 현재 스크롤된 위치
                let contentHeight = self.tableView.contentSize.height /// 전체 content 높이

                if offSetY > (contentHeight - self.tableView.frame.size.height - 100) {
                    if self.viewModel.startCounter > 1 {
                        self.viewModel.fetchMoreDatas.onNext(())
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}
