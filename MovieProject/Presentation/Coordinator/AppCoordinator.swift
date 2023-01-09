//
//  AppCoordinator.swift
//  MovieProject
//
//  Created by 강호성 on 2023/01/09.
//

import UIKit

/// 시작 흐름 정의 프로토콜
protocol AppCoordinatorProtocol: Coordinator {
    func connectMainFlow()
}

/// 모든 흐름의 시작점
final class AppCoordinator: AppCoordinatorProtocol {

    weak var delegate: CoordinatorDelegate?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var type: CoordinatorStyleCase = .main

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(false, animated: false)
    }

    func start() {
        connectMainFlow()
    }

    func connectMainFlow() {
        let searchCoordinator = SearchCoordinator(navigationController)
        searchCoordinator.delegate = self
        searchCoordinator.start()
        childCoordinators.append(searchCoordinator)
    }
}

// MARK: - CoordinatorDelegate
extension AppCoordinator: CoordinatorDelegate {
    func didFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0.type != childCoordinator.type }
        navigationController.viewControllers.removeAll()

        switch childCoordinator.type {
        case .main:
            connectMainFlow()
        }
    }
}
