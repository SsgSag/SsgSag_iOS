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
    
    let clubInfoData: BehaviorSubject<ClubInfo?> = BehaviorSubject<ClubInfo?>(value: nil)
    let reviewDataSet: BehaviorSubject<[ReviewInfo]?> = BehaviorSubject<[ReviewInfo]?>(value: nil)
    
    let recommendObservable:BehaviorRelay<Float> = BehaviorRelay(value: 0.0)
    let proObservable = BehaviorRelay(value: "")
    let funObservable = BehaviorRelay(value: "")
    let hardObservable = BehaviorRelay(value: "")
    let friendObservable = BehaviorRelay(value: "")
    
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
        switch score {
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
            return "F"
        }
    }
    
    func bind() {
        clubInfoData.subscribe(onNext: { [weak self] object in
            guard let object = object else { return }
            
            self?.proObservable.accept(self?.changeScoreToString(score: object.aveScore1) ?? "F")
            self?.funObservable.accept(self?.changeScoreToString(score: object.aveScore2) ?? "F")
            self?.hardObservable.accept(self?.changeScoreToString(score: object.aveScore3) ?? "F")
            self?.friendObservable.accept(self?.changeScoreToString(score: object.aveScore4) ?? "F")
            self?.recommendObservable.accept(object.aveScore0)
        })
        .disposed(by: disposeBag)
    }
}
