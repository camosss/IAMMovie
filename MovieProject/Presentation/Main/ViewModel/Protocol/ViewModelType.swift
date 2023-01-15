//
//  ViewModelType.swift
//  MovieProject
//
//  Created by 강호성 on 2023/01/15.
//

import Foundation
import RxSwift

protocol ViewModelType {

    associatedtype Input
    associatedtype Output

    var disposeBag: DisposeBag { get set }

    func transform(input: Input) -> Output
}
