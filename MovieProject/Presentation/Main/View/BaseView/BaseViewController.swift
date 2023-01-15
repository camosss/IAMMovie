//
//  BaseViewController.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/25.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {

    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setConfigurations()
        setViews()
        setConstraints()
    }

    func setViews() { }
    func setConstraints() { }

    func setConfigurations() {
        view.backgroundColor = .systemBackground
    }
}
