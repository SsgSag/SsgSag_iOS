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
    var reviewCount = 0
    
    let tabPageObservable: BehaviorSubject<Int> = BehaviorSubject<Int>(value: 0)
    let tabFirstButtonStatus: BehaviorSubject<Bool> = BehaviorSubject<Bool>(value: true)
    
    let clubInfoData: BehaviorSubject<ClubInfo?> = BehaviorSubject<ClubInfo?>(value: nil)
    let reviewDataSet: BehaviorSubject<[ReviewInfo]?> = BehaviorSubject<[ReviewInfo]?>(value: nil)
    
    let recommendObservable:BehaviorRelay<Float> = BehaviorRelay(value: 0.0)
    let proObservable = BehaviorRelay(value: "")
    let funObservable = BehaviorRelay(value: "")
    let hardObservable = BehaviorRelay(value: "")
    let friendObservable = BehaviorRelay(value: "")
    
    let proUnderObservable = BehaviorRelay(value: "")
    let funUnderObservable = BehaviorRelay(value: "")
    let hardUnderObservable = BehaviorRelay(value: "")
    let friendUnderObservable = BehaviorRelay(value: "")
    
    let disposeBag = DisposeBag()
    
    init() {
        bind()
    }
    
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
    
    func changeScoreToString(score: Float) -> String {
        switch (floorf(score * 10) / 10) {
        case 4.3...5.0:
            return "A"
        case 3.5...4.2:
            return "B"
        case 2.7...3.4:
            return "C"
        case 1.9...2.6:
            return "D"
        case 1.0...1.8:
            return "F"
        default:
            return "-"
        }
    }
    
    func changeRecommendScoreToString(score: Float) -> String {
        switch (floorf(score * 10) / 10) {
        case 4.3...5.0:
            return "최악"
        case 3.5...4.2:
            return "별로"
        case 2.7...3.4:
            return "쏘쏘"
        case 1.9...2.6:
            return "좋아요"
        case 1.0...1.8:
            return "최고에요"
        default:
            return "-"
        }
    }
    
    func changeFunScoreToString(score: Float) -> String {
        switch (floorf(score * 10) / 10) {
        case 4.3...5.0:
            return "개꿀잼"
        case 3.5...4.2:
            return "꿀잼"
        case 2.7...3.4:
            return "쏘쏘"
        case 1.9...2.6:
            return "노잼"
        case 1.0...1.8:
            return "핵노잼"
        default:
            return "-"
        }
    }
    
    func changeProScoreToString(score: Float) -> String {
        switch (floorf(score * 10) / 10) {
        case 4.3...5.0:
            return "매우 높음"
        case 3.5...4.2:
            return "높음"
        case 2.7...3.4:
            return "쏘쏘"
        case 1.9...2.6:
            return "낮음"
        case 1.0...1.8:
            return "매우 낮음"
        default:
            return "-"
        }
    }
    
    func changeHardScoreToString(score: Float) -> String {
        switch (floorf(score * 10) / 10) {
        case 4.3...5.0:
            return "널널"
        case 3.5...4.2:
            return "안빡셈"
        case 2.7...3.4:
            return "쏘쏘"
        case 1.9...2.6:
            return "빡셈"
        case 1.0...1.8:
            return "사망"
        default:
            return "-"
        }
    }
    
    func changeFriendScoreToString(score: Float) -> String {
        switch (floorf(score * 10) / 10) {
        case 4.3...5.0:
            return "매우 좋음"
        case 3.5...4.2:
            return "좋음"
        case 2.7...3.4:
            return "쏘쏘"
        case 1.9...2.6:
            return "별로"
        case 1.0...1.8:
            return "전혀"
        default:
            return "-"
        }
    }
    
    
    func bind() {
        clubInfoData.subscribe(onNext: { [weak self] object in
            guard let object = object else { return }
            self?.reviewCount = object.scoreNum
            self?.proObservable.accept(self?.changeScoreToString(score: object.aveScore1) ?? "-")
            self?.funObservable.accept(self?.changeScoreToString(score: object.aveScore2) ?? "-")
            self?.hardObservable.accept(self?.changeScoreToString(score: object.aveScore3) ?? "-")
            self?.friendObservable.accept(self?.changeScoreToString(score: object.aveScore4) ?? "-")
            self?.proUnderObservable.accept(self?.changeProScoreToString(score: object.aveScore1) ?? "-")
            self?.funUnderObservable.accept(self?.changeFunScoreToString(score: object.aveScore2) ?? "-")
            self?.hardUnderObservable.accept(self?.changeHardScoreToString(score: object.aveScore3) ?? "-")
            self?.friendUnderObservable.accept(self?.changeFriendScoreToString(score: object.aveScore4) ?? "-")
            self?.recommendObservable.accept(object.aveScore0)
        })
        .disposed(by: disposeBag)
    }
}
