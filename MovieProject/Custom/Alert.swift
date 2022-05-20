//
//  Alert.swift
//  MovieProject
//
//  Created by 강호성 on 2022/05/21.
//

import UIKit

typealias Action = () -> ()

final class Alert {
    static func actionSheetAlert(
        title: String,
        cancel: String,
        first: String,
        second: String,
        third: String,
        onFirst: @escaping (Action),
        onSecond: @escaping (Action),
        onThird: @escaping (Action),
        over viewController: UIViewController
    ) {
        let alert = UIAlertController(
            title: title,
            message: nil,
            preferredStyle: .actionSheet
        )

        let first = UIAlertAction(title: first, style: .default) { _ in
            onFirst()
        }

        let second = UIAlertAction(title: second, style: .default) { _ in
            onSecond()
        }

        let third = UIAlertAction(title: third, style: .default) { _ in
            onThird()
        }
        
        let cancel = UIAlertAction(title: cancel, style: .cancel)

        alert.addAction(first)
        alert.addAction(second)
        alert.addAction(third)
        alert.addAction(cancel)
        viewController.present(alert, animated: true, completion: nil)
    }
}
