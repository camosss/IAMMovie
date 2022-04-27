//
//  StarButton.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/27.
//

import UIKit
import SnapKit

final class StarButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConfigurations()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setConfigurations() {
        setImage(UIImage(systemName: "star"), for: .normal)
        setImage(UIImage(systemName: "star.fill"), for: .selected)
        imageView?.tintColor = .systemYellow
        contentMode = .scaleAspectFit
    }
}
