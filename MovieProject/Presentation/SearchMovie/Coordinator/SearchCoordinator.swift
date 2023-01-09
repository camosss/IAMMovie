//
//  SearchCoordinator.swift
//  MovieProject
//
//  Created by 강호성 on 2023/01/09.
//

import UIKit

protocol SearchCoordinatorProtocol: Coordinator {
    func showSearchViewController()
}

final class SearchCoordinator: SearchCoordinatorProtocol {

    weak var delegate: CoordinatorDelegate?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var type: CoordinatorStyleCase = .main

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(false, animated: false)
    }

    deinit {
        print("deinit SearchCoordinator")
    }

    func start() {
        showSearchViewController()
    }

    func showSearchViewController() {
        let vc = SearchMovieViewController()
        navigationController.pushViewController(vc, animated: true)
    }
}

// MARK: - CoordinatorDelegate
extension SearchCoordinator: CoordinatorDelegate {
    func didFinish(childCoordinator: Coordinator) {
        self.delegate?.didFinish(childCoordinator: self)
    }
}
