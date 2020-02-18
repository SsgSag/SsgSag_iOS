//
//  ClubEditViewModel.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/17.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ClubEditViewModel {
    let clubNameObservable = BehaviorRelay(value: "")
    let univObservable = BehaviorRelay(value: "")
    let locationObservable: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    let oneLineObservable = BehaviorRelay(value: "")
    let categoryObservable: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    
    let disposeBag = DisposeBag()
    
    let service: ClubServiceProtocol!
    
    init(model: ClubInfo, service: ClubServiceProtocol = ClubService()) {
        self.service = service
//        clubNameObservable = model.clubName
        
    }
    
    func isMaxCategory() -> Bool {
        if categoryObservable.value.count >= 3 {
            return true
        }
        return false
    }
    
    func deleteCategory(index: Int) {
        var tempCategoryArray = categoryObservable.value
        tempCategoryArray.remove(at: index)
        categoryObservable.accept(tempCategoryArray)
    }
    
}
