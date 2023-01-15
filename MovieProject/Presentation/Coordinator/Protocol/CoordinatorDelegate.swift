//
//  CoordinatorDelegate.swift
//  MovieProject
//
//  Created by 강호성 on 2023/01/15.
//

import Foundation

protocol CoordinatorDelegate: AnyObject {
    func didFinish(childCoordinator: Coordinator)
}
