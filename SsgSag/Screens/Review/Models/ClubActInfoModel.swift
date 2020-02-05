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
    var location = BehaviorRelay(value: "")
    var schoolName: String?
    var startDate = BehaviorRelay(value: "")
    var endDate = BehaviorRelay(value: "")
    var startRequestDate: String?
    var endRequestDate: String?
    
    init(clubType: ClubType) {
        self.clubType = clubType
    }
}
