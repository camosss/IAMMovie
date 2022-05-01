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
        configureCell: { [weak self] dataSource, tableView, indexPath, item in
            guard let self = self else { return UITableViewCell() }
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
        title = "즐겨찾기 목록"

        tableView.refreshControl = refreshControl
        tableView.register(MovieCell.self,
                           forCellReuseIdentifier: MovieCell.reuseIdentifier)
    }
    
    private func bind() {
        tableViewBind()

        refreshControl.rx
            .controlEvent(.valueChanged)
            .bind { [weak self] _ in
                guard let self = self else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.viewModel.refreshControlAction.onNext(()) /// 새로고침 실행여부 이벤트 전달
                }
            }
            .disposed(by: disposeBag)

        viewModel.refreshControlCompelted
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.refreshControl.endRefreshing()
            }
            .disposed(by: disposeBag)
    }

    private func tableViewBind() {
        /// 검색 결괏값 0일 때, EmptyView
        viewModel.favoriteList
            .map { return $0.count <= 0 }
            .bind(to: tableView.rx.isEmpty(
                title: "즐겨찾기 목록이 비었습니다.",
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
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.tableView.deselectRow(at: indexPath, animated: false)

                let movie = self.viewModel.favoriteList.value[indexPath.row]
                let controller = DetailMovieViewController(movie: movie)
                self.navigationController?.pushViewController(controller, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
