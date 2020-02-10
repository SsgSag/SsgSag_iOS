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
        Observable.combineLatest(clubNameObservable, univOrLocationObservable, oneLineObservable, categoryObservable, resultSelector: {
            self.emptyStringCheck(text: $0) &&
            self.emptyStringCheck(text: $1) &&
            self.emptyStringCheck(text: $2) &&
                self.emptyArrayCheck(arr: $3 )
        }).distinctUntilChanged()
            .bind(to: nextButtonEnableObservable)
            .disposed(by: disposeBag)
    }
    
    func emptyStringCheck(text: String) -> Bool {
        return !text.isEmpty
    }
    
    func emptyArrayCheck(arr: [String]) -> Bool {
        return !arr.isEmpty
    }
    
    func isMaxCategory() -> Bool {
        if categoryObservable.value.count >= 3 {
            return true
        }
        return false
    }
    
    func deleteCategory(index: Int) {
        var tempCategoryArray = categoryObservable.value
        tempCategoryArray.remove(at: index)
        categoryObservable.accept(tempCategoryArray)
    }
    
    deinit {
        print("deinit - clubregister")
    }
}
