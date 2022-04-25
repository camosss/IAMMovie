//
//  AppAppearance.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/25.
//

import UIKit

final class AppAppearance {
    static func setupAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        let backImage = UIImage()
        appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = .basic
        UINavigationBar.appearance().barTintColor = .basic
    }
}

