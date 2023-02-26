//
//  MainCoordinator.swift
//  MovieProject
//
//  Created by 강호성 on 2023/01/09.
//

import UIKit

protocol MainCoordinatorProtocol: Coordinator {
    func showSearchViewController()
}

final class MainCoordinator: MainCoordinatorProtocol {

    weak var delegate: CoordinatorDelegate?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var type: CoordinatorStyleCase = .main

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(false, animated: false)
    }

    deinit {
        print("deinit MainCoordinator")
    }

    func start() {
        showSearchViewController()
    }

    func showSearchViewController() {
        let vc = SearchViewController(
            viewModel: SearchViewModel(
                coordinator: self,
                useCase: SearchUseCase(
                    repository: SearchRepository()
                )
            )
        )
        navigationController.pushViewController(vc, animated: true)
    }

    func showFavoriteViewController() {
        let vc = FavoritesViewController()
        navigationController.pushViewController(vc, animated: true)
    }
}

// MARK: - CoordinatorDelegate
extension MainCoordinator: CoordinatorDelegate {
    func didFinish(childCoordinator: Coordinator) {
        self.delegate?.didFinish(childCoordinator: self)
    }
}
