//
//  DetailMovieViewController.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/26.
//

import UIKit

final class DetailMovieViewController: BaseViewController {

    // MARK: - Properties

    private let movie: Movie?
    private let headerView = DetailHeaderView()

    // MARK: - Initializer

    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Helpers

    override func setViews() {
        super.setViews()
        view.addSubview(headerView)
    }

    override func setConstraints() {
        super.setConstraints()
        headerView.snp.makeConstraints { make in
            make.height.equalTo(100).priority(750)
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }

    override func setConfigurations() {
        super.setConfigurations()
        if let movie = movie {
            title = "\(movie.title ?? "")(\(movie.pubDate ?? ""))"
            headerView.configure(movie: movie)
        }
    }
}
