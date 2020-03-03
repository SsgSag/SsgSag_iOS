//
//  CoachMarkViewModel.swift
//  SsgSag
//
//  Created by bumslap on 01/03/2020.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class CoachMarkViewModel {
    let type: CoachMarkType
    //Filtering
    let filteringButtonIsHidden = BehaviorRelay<Bool>(value: true)
    let filteringDescriptionIsHidden = BehaviorRelay<Bool>(value: true)
    //SwipeMain
    let swipeDescriptionIsHidden = BehaviorRelay<Bool>(value: true)
    //SwipeDetail
    let swipeDetailImageViewIsHidden = BehaviorRelay<Bool>(value: true)
    //Feed
    let feedImageViewIsHidden = BehaviorRelay<Bool>(value: true)
    //Calendar
    let calendarImageViewIsHidden = BehaviorRelay<Bool>(value: true)
    
    let almostClear = UIColor.clear
    let backgroundColor = BehaviorRelay<UIColor>(value: .clear)
    
    init(with type: CoachMarkType) {
        self.type = type
        
        switch type {
        case .filtering:
            backgroundColor.accept(#colorLiteral(red: 0.3960784314, green: 0.431372549, blue: 0.9411764706, alpha: 0.5))
            filteringButtonIsHidden.accept(false)
            filteringDescriptionIsHidden.accept(false)
        case .swipeMain:
            backgroundColor.accept(almostClear)
            swipeDescriptionIsHidden.accept(false)
        case .swipeDetail:
            backgroundColor.accept(almostClear)
            swipeDetailImageViewIsHidden.accept(false)
        case .feed:
            backgroundColor.accept(almostClear)
            feedImageViewIsHidden.accept(false)
        case .calendar:
            backgroundColor.accept(almostClear)
            calendarImageViewIsHidden.accept(false)
        }
    }
}
