//
//  Coordinator.swift
//  MovieProject
//
//  Created by 강호성 on 2023/01/09.
//

import UIKit

enum CoordinatorStyleCase {
    case main
}

protocol Coordinator: AnyObject {

    var delegate: CoordinatorDelegate? { get set }
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    var type: CoordinatorStyleCase { get }

    func start()
    func finish()

    init(_ navigationController: UINavigationController)
}

extension Coordinator {
    func finish() {
        childCoordinators.removeAll()
        delegate?.didFinish(childCoordinator: self)
    }
}
