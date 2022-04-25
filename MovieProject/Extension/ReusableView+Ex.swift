//
//  ReusableView+Ex.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/25.
//

import UIKit

protocol ReusableView {
    static var reuseIdentifier: String { get }
}

extension UITableViewCell: ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
