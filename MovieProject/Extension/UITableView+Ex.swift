//
//  UITableView+Ex.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/27.
//

import UIKit

extension UITableView {
    func setEmptyBackgroundView(title: String, imageName: String) {
        self.backgroundView = EmptyView(
            frame: CGRect(x: 0,
                          y: 0,
                          width: self.bounds.width,
                          height: self.bounds.height),
            text: title,
            imageName: imageName)
        self.isScrollEnabled = false
        self.separatorStyle = .none
    }

    func removeBackgroundView() {
         self.isScrollEnabled = true
         self.backgroundView = nil
         self.separatorStyle = .singleLine
     }
}
