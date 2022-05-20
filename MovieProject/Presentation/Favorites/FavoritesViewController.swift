//
//  FavoritesViewController.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/27.
//

import UIKit

import RxCocoa
import RxDataSources
import RxSwift

final class FavoritesViewController: BaseViewController {

    // MARK: - Properties

    private let disposeBag = DisposeBag()
    private let viewModel = FavoritesViewModel()

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let refreshControl = UIRefreshControl()

    private lazy var dataSource = RxTableViewSectionedReloadDataSource<FavoritesSection.FavoritesSectionModel>(
        configureCell: { dataSource, tableView, indexPath, item in
            switch item {
            case .firstItem(let movie):
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: MovieCell.reuseIdentifier,
                    for: indexPath
                ) as! MovieCell
                cell.configure(movie: movie)
                return cell
            }
        }
    )

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
        title = Localization.favorites.description.localization()

        tableView.refreshControl = refreshControl
        tableView.register(MovieCell.self,
                           forCellReuseIdentifier: MovieCell.reuseIdentifier)
    }
    
    private func bind() {
        tableViewBind()

        refreshControl.rx
            .controlEvent(.valueChanged)
            .withUnretained(self)
            .bind { owner, _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    owner.viewModel.refreshControlAction.onNext(()) /// 새로고침 실행여부 이벤트 전달
                }
            }
            .disposed(by: disposeBag)

        viewModel.refreshControlCompelted
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.refreshControl.endRefreshing()
            }
            .disposed(by: disposeBag)
    }

    private func tableViewBind() {
        /// 검색 결괏값 0일 때, EmptyView
        viewModel.favoriteList
            .map { return $0.count <= 0 }
            .bind(to: tableView.rx.isEmpty(
                title: Localization.empty_Favorites.description.localization(),
                imageName: "scribble.variable"
            ))
            .disposed(by: disposeBag)

        /// tableView dataSource
        viewModel.favoriteList
            .asDriver()
            .map { value in
                return [FavoritesSection.FavoritesSectionModel(
                    model: 0,
                    items: value.map{FavoritesSection.MoviesItems.firstItem($0)}
                )]
            }
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        /// DetailView로 전환
        tableView.rx
            .itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                owner.tableView.deselectRow(at: indexPath, animated: false)

                let movie = owner.viewModel.favoriteList.value[indexPath.row]
                let controller = DetailMovieViewController(movie: movie)
                owner.navigationController?.pushViewController(controller, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
