//
//  SimpleReviewViewModel.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/07.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class SimpleReviewViewModel {
    let oneLineObservable = BehaviorRelay(value: "")
    let advantageObservable = BehaviorRelay(value: "")
    let disadvantageObservable = BehaviorRelay(value: "")
    let honeyObservable = BehaviorRelay(value: "")
    let submitButtonEnableObservable = BehaviorRelay(value: false)
    let disposeBag = DisposeBag()
    
    init() {
        bind()
    }
    
    func bind() {
        Observable.combineLatest(oneLineObservable, advantageObservable, disadvantageObservable, resultSelector: {
            return self.checkEmpty(text: $0) && self.checkMinmumText(text: $1) && self.checkMinmumText(text: $2)
        })
            .distinctUntilChanged()
            .bind(to: submitButtonEnableObservable)
            .disposed(by: disposeBag)
    }
    
    func checkEmpty(text: String) -> Bool {
        return text.count > 0
    }
    
    func checkMinmumText(text: String) -> Bool {
        return text.count >= 20
    }
}
