//
//  DefaultLabel.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/25.
//

import UIKit.UILabel

final class DefaultLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(font: UIFont, textColor: UIColor) {
        self.init()
        self.font = font
        self.textColor = textColor
    }
}
