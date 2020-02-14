//
//  ReviewEditViewModel.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/14.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ReviewEditViewModel {
    var inputType: InputType = .none
    var clubName = ""
    var location = BehaviorRelay(value: "")
    let startDate = BehaviorRelay(value: "")
    let endDate = BehaviorRelay(value: "")
    
    let recommendDegreeObservable = BehaviorRelay(value: -1)
    let funDegreeObservable = BehaviorRelay(value: -1)
    let proDegreeObservable = BehaviorRelay(value: -1)
    let hardDegreeObservable = BehaviorRelay(value: -1)
    let friendDegreeObservable = BehaviorRelay(value: -1)
    
    let oneLineObservable = BehaviorRelay(value: "")
    let advantageObservable = BehaviorRelay(value: "")
    let disadvantageObservable = BehaviorRelay(value: "")
    let honeyObservable = BehaviorRelay(value: "")
    let disposeBag = DisposeBag()
    
    let reviewService: ReviewServiceProtocol
    let reviewInfo: ReviewInfo
    
    init(model: ReviewInfo, service: ReviewServiceProtocol = ReviewService()) {
        self.reviewService = service
        self.reviewInfo = model
    }
    
    func bind() {
        //
        // 모델 값넣어주기
        //
        //
    }
    
    func checkMinmumText(text: String) -> Bool {
        return text.count >= 20
    }
}
