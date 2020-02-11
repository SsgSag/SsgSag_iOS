//
//  ClubRegisterTwoStepViewModel.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/10.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ClubRegisterTwoStepViewModel {
    let activeMemberObservable = BehaviorRelay(value: "")
    let meetingTimeObservable = BehaviorRelay(value: "")
    let feeObservable = BehaviorRelay(value: "")
    let clubSiteObservable = BehaviorRelay(value: "")
    let introduceObservable = BehaviorRelay(value: "")
    let photoDataObservable:BehaviorRelay<[Data]> = BehaviorRelay(value: [])
    let photoURLObservable:BehaviorRelay<[String]> = BehaviorRelay(value: [])
    let nextButtonEnableObservable = BehaviorRelay(value: false)
    private let maxCount = 9
    let disposeBag = DisposeBag()
    
    init() {
        bind()
    }
    
    func bind() {
        Observable.combineLatest(activeMemberObservable, meetingTimeObservable, feeObservable, introduceObservable, resultSelector: {
            return self.emptyStringCheck(text: $0) &&
                    self.emptyStringCheck(text: $1) &&
                    self.emptyStringCheck(text: $2) &&
                    self.emptyStringCheck(text: $3)
        })
        .distinctUntilChanged()
        .bind(to: nextButtonEnableObservable)
        .disposed(by: disposeBag)
    }
    
    func isMaxPhoto() -> Bool {
        if photoDataObservable.value.count >= maxCount {
            return true
        }
        return false
    }
    
    func deletePhoto(index: Int) {
        var tempPhotoArray = photoDataObservable.value
        tempPhotoArray.remove(at: index)
        photoDataObservable.accept(tempPhotoArray)
    }
    
    func emptyStringCheck(text: String) -> Bool {
        return !text.isEmpty
    }
}
