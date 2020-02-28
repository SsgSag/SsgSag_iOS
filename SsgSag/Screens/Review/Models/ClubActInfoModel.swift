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
    case location, start, end, none, category
}

class ClubActInfoModel {
    var clubType: ClubType
    var inputType: InputType = .none
    var clubName = ""
    var isExistClub = false
    var clubIdx = -1
    var location = BehaviorRelay(value: "")
    var univName = ""
    var startDate = BehaviorRelay(value: "")
    var endDate = BehaviorRelay(value: "")
    var startRequestDate = ""
    var endRequestDate = ""
    var startSaveDate: Date?
    var endSaveDate: Date?
    var categoryList: [String] = []
    
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
    
    func categoryListToString() -> String {
        var stringList = ""
        for index in 0..<categoryList.count {
            let category = categoryList[index]
            if index == categoryList.count - 1 {
                stringList.append(contentsOf: "\(category)")
            } else {
                stringList.append(contentsOf: "\(category),")
            }
        }
        return stringList
    }
    
    func editBind(model: ReviewEditViewModel) {
        recommendScore = model.recommendDegreeObservable.value+1
        funScore = model.funDegreeObservable.value+1
        proScore = model.proDegreeObservable.value+1
        hardScore = model.hardDegreeObservable.value+1
        friendScore = model.friendDegreeObservable.value+1
        
        oneLineString = model.oneLineObservable.value
        advantageString = model.advantageObservable.value
        disadvantageString = model.disadvantageObservable.value
        honeyString = model.honeyObservable.value
        
    }
}
