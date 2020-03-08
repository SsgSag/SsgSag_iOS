//
//  MyClubTableViewCellViewModeel.swift
//  SsgSag
//
//  Created by bumslap on 07/03/2020.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MyClubCellViewModel {
    
    let clubTypeText = BehaviorRelay<String>(value: "")
    let titleText = BehaviorRelay<String>(value: "")
    let dateText = BehaviorRelay<String>(value: "")
    let approvalText = BehaviorRelay<String>(value: "")
    
    init(clubType: Int,
         titleText: String,
         dateText: String,
         approval: Int) {
        let clubTypeText = clubType == 0 ? "교내" : "연합"
        let approvalText = approval == 0 ? "승인 대기중" : "거절"
        let editedDateText = "작성일: " + String(dateText.split(separator: " ").first ?? "")
        self.clubTypeText.accept(clubTypeText)
        self.titleText.accept(titleText)
        self.dateText.accept(editedDateText)
        self.approvalText.accept(approvalText)
    }
}
