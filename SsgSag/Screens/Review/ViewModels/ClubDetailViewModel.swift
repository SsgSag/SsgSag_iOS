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
    
    func setPage(page: Int) {
        self.tabPageObservable.onNext(page)
    }
    
    func setButton(select: Bool) {
        self.tabFirstButtonStatus.onNext(select)
    }
}
