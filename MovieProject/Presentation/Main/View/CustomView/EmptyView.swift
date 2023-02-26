//
//  EmptyView.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/27.
//

import UIKit

final class EmptyView: BaseUIView {

    // MARK: - Properties

    private let imageView = UIImageView()
    private let textLabel = DefaultLabel(font: .headline, textColor: .lightGray)

    // MARK: - Initializer

    convenience init(frame: CGRect, text: String, imageName: String) {
        self.init(frame: frame)
        textLabel.text = text
        imageView.image = UIImage(systemName: imageName)
    }

    // MARK: - Helpers

    override func setView() {
        super.setView()
        addSubview(imageView)
        addSubview(textLabel)
    }

    override func setConstraints() {
        super.setConstraints()
        imageView.snp.makeConstraints { make in
            make.top.equalTo(150)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
    }

    override func setConfiguration() {
        super.setConfiguration()
        imageView.tintColor = .lightGray
        imageView.contentMode = .scaleToFill
        textLabel.textAlignment = .center
    }
}
