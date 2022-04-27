//
//  SearchBar.swift
//  MovieProject
//
//  Created by 강호성 on 2022/04/27.
//

import UIKit

import RxCocoa
import RxSwift

final class SearchBar: UISearchBar {

    // MARK: - Properties

    private let disposeBag = DisposeBag()
    private let searchButton = UIButton()

    var shouldLoadResult = Observable<String>.of("") /// 검색 text 전달
    let searchButtonTapped = PublishRelay<Void>()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.accessibilityIdentifier = "searchBar"
        self.searchButton.accessibilityIdentifier = "searchButton"

        setView()
        setConstraints()
        setConfigurations()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helpers

    private func bind() {
        Observable
            .merge (
                self.rx.searchButtonClicked.asObservable(),
                searchButton.rx.tap.asObservable()
            )
            .bind(to: searchButtonTapped)
            .disposed(by: disposeBag)

        searchButtonTapped
            .asSignal() /// PublishRelay -> observable()
            .emit(to: self.rx.endEditing) /// 키보드 내려가는 이벤트 방출
            .disposed(by: disposeBag)

        /// searchButtonTapped 실행 -> 검색 text를 전달하는 shouldLoadResult 실행
        self.shouldLoadResult = searchButtonTapped
            .withLatestFrom(self.rx.text) { $1 ?? "" } /// 최신 text를 전달
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
    }

    private func setView() {
        addSubview(searchButton)
    }

    private func setConstraints() {
        searchTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalTo(searchButton.snp.leading).offset(-12)
            $0.centerY.equalToSuperview()
        }
        searchButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
        }
    }

    private func setConfigurations() {
        searchButton.setTitle("검색", for: .normal)
        searchButton.setTitleColor(.label, for: .normal)
    }
}
