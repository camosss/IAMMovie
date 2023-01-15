//
//  BaseUIView.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/26.
//

import UIKit.UIView

class BaseUIView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setConstraints()
        setConfiguration()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setView() { }
    func setConstraints() { }
    func setConfiguration() { }
}
