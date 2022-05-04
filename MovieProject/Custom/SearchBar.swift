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

    var shouldLoadResult = Observable<String>.of("") /// 상위 View로 검색 text 전달
    let searchButtonTapped = PublishRelay<Void>() /// 키보드의 검색 버튼 트리거

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helpers

    private func bind() {
        self.rx.searchButtonClicked
            .asObservable() /// ControlEvent → observable()
            .bind(to: searchButtonTapped)
            .disposed(by: disposeBag)

        searchButtonTapped
            .asSignal() /// PublishRelay → observable()
            .emit(to: self.rx.endEditing) /// 키보드 내려가는 이벤트 방출
            .disposed(by: disposeBag)

        /// searchButtonTapped 실행 -> 검색 text를 전달하는 shouldLoadResult 실행
        self.shouldLoadResult = searchButtonTapped
            .withLatestFrom(self.rx.text) { $1 ?? "" } /// 최신 text를 전달
            .filter { !$0.isEmpty }
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
    }

    private func setConstraints() {
        searchTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
        }
    }
}
