//
//  UIImageView+Ex.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/25.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(with urlString: String) {
        self.kf.setImage(with: URL(string: urlString))
    }
}
