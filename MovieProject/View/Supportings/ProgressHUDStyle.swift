//
//  ProgressHUDStyle.swift
//  MovieProject
//
//  Created by 강호성 on 2022/05/01.
//

import UIKit
import ProgressHUD

final class ProgressHUDStyle {
    static func configureHUD(text: String, icon: AlertIcon, color: UIColor) {
        ProgressHUD.colorAnimation = color
        ProgressHUD.show(text, icon: icon)
    }
}
