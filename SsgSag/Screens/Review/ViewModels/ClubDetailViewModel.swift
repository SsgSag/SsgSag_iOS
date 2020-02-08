//
//  ClubDetailViewModel.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/28.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ClubDetailViewModel {
    
    let tabPageObservable: BehaviorSubject<Int> = BehaviorSubject<Int>(value: 0)
    let tabFirstButtonStatus: BehaviorSubject<Bool> = BehaviorSubject<Bool>(value: true)
//    var clubInfoData: ClubInfo?
//    var reviewDataSet: [ReviewInfo] = []
    
    let clubInfoData: BehaviorSubject<ClubInfo?> = BehaviorSubject<ClubInfo?>(value: nil)
    let reviewDataSet: BehaviorSubject<[ReviewInfo]?> = BehaviorSubject<[ReviewInfo]?>(value: nil)
    
    func setPage(page: Int) {
        self.tabPageObservable.onNext(page)
    }
    
    func setButton(select: Bool) {
        self.tabFirstButtonStatus.onNext(select)
    }
    
    func setData(data: ClubInfo) {
        self.clubInfoData.onNext(data)
        self.reviewDataSet.onNext(data.clubPostList)
    }
}
