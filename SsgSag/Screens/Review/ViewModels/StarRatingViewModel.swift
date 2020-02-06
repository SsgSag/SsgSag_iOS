//
//  StarRatingViewModel.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/06.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class StarRatingViewModel {
    let recommendDegreeObservable = BehaviorRelay(value: -1)
    let funDegreeObservable = BehaviorRelay(value: -1)
    let proDegreeObservable = BehaviorRelay(value: -1)
    let hardDegreeObservable = BehaviorRelay(value: -1)
    let friendDegreeObservable = BehaviorRelay(value: -1)
    let nextButtonEnableObservable = BehaviorRelay(value: false)
    let disposeBag = DisposeBag()
    
    init() {
        bind()
    }
    
    func bind() {
        Observable
            .zip(funDegreeObservable, proDegreeObservable, hardDegreeObservable, friendDegreeObservable, resultSelector: {$0+$1+$2+$3 >= 0})
            .bind(onNext: { [weak self] bool in
                self?.nextButtonEnableObservable.accept(bool)
            })
            .disposed(by: disposeBag)
    }
}
