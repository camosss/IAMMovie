//
//  UIViewController+Ex.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/25.
//

import UIKit

extension UIViewController {
    func configureLeftBarButtonItem(title: String) {
        let label = DefaultLabel(font: .title2, textColor: .basic)
        label.text = title

        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
    }
}
