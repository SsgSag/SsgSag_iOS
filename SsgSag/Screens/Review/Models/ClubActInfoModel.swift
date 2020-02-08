//
//  ClubActInfoModel.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/04.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum InputType {
    case location, start, end, none
}

class ClubActInfoModel {
    var clubType: ClubType
    var inputType: InputType = .none
    var clubName: String?
    var isExistClub = false
    var clubIdx: Int?
    var location = BehaviorRelay(value: "")
    var schoolName: String?
    var startDate = BehaviorRelay(value: "")
    var endDate = BehaviorRelay(value: "")
    var startRequestDate: String?
    var endRequestDate: String?
    
    var recommendScore = 0
    var funScore = 0
    var proScore = 0
    var hardScore = 0
    var friendScore = 0
    
    var oneLineString = ""
    var advantageString = ""
    var disadvantageString = ""
    var honeyString = ""
    
    var reviewService: ReviewServiceProtocol
    
    init(clubType: ClubType, service: ReviewServiceProtocol = ReviewService()) {
        self.clubType = clubType
        self.reviewService = service
    }
    
    func starRatingBind(model: StarRatingViewModel) {
        
        recommendScore = model.recommendDegreeObservable.value+1
        funScore = model.funDegreeObservable.value+1
        proScore = model.proDegreeObservable.value+1
        hardScore = model.hardDegreeObservable.value+1
        friendScore = model.friendDegreeObservable.value+1
    }
    
    func simpleReivewBind(model: SimpleReviewViewModel) {
        
        oneLineString = model.oneLineObservable.value
        advantageString = model.advantageObservable.value
        disadvantageString = model.disadvantageObservable.value
        honeyString = model.honeyObservable.value
    }
    
    func submitRequest() -> Bool {
        
        return isExistClub ? reviewService.requestExistClubReviewPost(model: self) : reviewService.requestNonExistClubReviewPost(model: self)
    }
}
