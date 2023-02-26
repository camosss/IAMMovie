//
//  LoadingView.swift
//  MovieProject
//
//  Created by 강호성 on 2023/02/26.
//

import UIKit

final class LoadingView: BaseUIView {

    override func setConfiguration() {
        super.setConfiguration()
        ProgressHUDStyle.configureHUD(text: "검색중..", icon: .search, color: .green)
    }
}
