//
//  ClubRegisterOneStepViewModel.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/09.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ClubRegisterOneStepViewModel {
    let clubNameObservable = BehaviorRelay(value: "")
    let univOrLocationObservable = BehaviorRelay(value: "")
    let oneLineObservable = BehaviorRelay(value: "")
    let categoryObservable: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    let nextButtonEnableObservable = BehaviorRelay(value: false)
    let disposeBag = DisposeBag()
    
    init() {
        bind()
    }
    
    func bind() {
        Observable.combineLatest(clubNameObservable, univOrLocationObservable, oneLineObservable, resultSelector: {
            self.emptyCheck(text: $0) &&
            self.emptyCheck(text: $1) &&
            self.emptyCheck(text: $2)
        }).distinctUntilChanged()
            .bind(to: nextButtonEnableObservable)
            .disposed(by: disposeBag)
    }
    
    func emptyCheck(text: String) -> Bool {
        return !text.isEmpty
    }
    
    func isMaxCategory() -> Bool {
        if categoryObservable.value.count >= 3 {
            return true
        }
        return false
    }
    
    deinit {
        print("deinit - clubregister")
    }
}
