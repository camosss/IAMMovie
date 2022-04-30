//
//  DetailMovieViewController.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/26.
//

import UIKit
import WebKit

final class DetailMovieViewController: BaseViewController {

    // MARK: - Properties

    private let movie: Movie?
    private let headerView = DetailHeaderView()
    private let webView = WKWebView().then {
        $0.allowsBackForwardNavigationGestures = true
    }

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
        showMovieWebView()
    }

    // MARK: - Helpers

    override func setViews() {
        super.setViews()
        view.addSubview(headerView)
        view.addSubview(webView)
    }

    override func setConstraints() {
        super.setConstraints()
        headerView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        webView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.bottom.equalTo(view)
        }
    }

    override func setConfigurations() {
        super.setConfigurations()
        if let movie = movie {
            title = (movie.title)
                .replacingOccurrences(of: "</b>", with: "")
                .replacingOccurrences(of: "<b>", with: "")
            headerView.configure(movie: movie)
        }
    }

    private func showMovieWebView() {
        if let movie = movie, let url = URL(string: movie.link) {
            let request = URLRequest(url: url)
            self.webView.load(request)
        }
    }
}
