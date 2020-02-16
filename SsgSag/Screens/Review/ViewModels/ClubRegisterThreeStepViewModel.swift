//
//  ClubRegisterThreeStepViewModel.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/10.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ClubRegisterThreeStepViewModel {
    let emailObservable = BehaviorRelay(value: "")
    let phoneObservable = BehaviorRelay(value: "")
    let submitButtonEnableObservable = BehaviorRelay(value: false)
    let disposeBag = DisposeBag()
    
    init() {
        bind()
    }
    
    func bind() {
        Observable.combineLatest(emailObservable, phoneObservable, resultSelector: {
            return self.emptyStringCheck(text: $0) &&
                self.emptyStringCheck(text: $1)
            })
        .bind(to: submitButtonEnableObservable)
        .disposed(by: disposeBag)
    }
    
    func emptyStringCheck(text: String) -> Bool {
        return !text.isEmpty
    }
}
