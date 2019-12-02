//
//  MyFilterSliderCollectionViewCell.swift
//  SsgSag
//
//  Created by bumslap on 24/11/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import RxSwift
import ReactorKit

class MyFilterSliderCollectionViewCellReactor: Reactor, MyFilterCollectionViewCellReactor {
    
    let itemsSize: CGSize
    let spacing: CGFloat
    
    var gradeCellReactors: [MyFilterGradeCollectionViewCellReactor] = []
    enum Action {
        case set(Int)
        case increase
        case decrease
     }

    enum Mutation {
        case setValue(Int)
        case increaseValue
        case decreaseValue
     }

    struct State {
        var grades: [Int]
        var value: Int
        var maxValue: Int
     }
    
    let initialState: State

    init(maxValue:Int, currentValue: Int) {
        let currentValue = currentValue
        
        self.initialState = State(grades: Array(1..<6),
                                  value: currentValue,
                                  maxValue: maxValue)
        let calculatedItemSize = MyFilterSizeLayout.calculateItemSize(by: .userGrade)
        let itemWidth = calculatedItemSize.width / CGFloat(maxValue - 1)
        self.itemsSize = .init(width: 16, height: 19)
        self.spacing = itemWidth - 16 - 8
            
        
        self.gradeCellReactors = (1...maxValue).map {
            let isSelected = $0 == currentValue
            if $0 == maxValue {
                return  MyFilterGradeCollectionViewCellReactor(gradeText: "\(maxValue)+",
                    isSelected: isSelected, index: $0 - 1)
            } else {
                return MyFilterGradeCollectionViewCellReactor(gradeText: "\($0)",
                    isSelected: isSelected, index: $0 - 1)
            }
        }
    }

       // Action -> Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .set(let value):
            return Observable.just(Mutation.setValue(value))
        case .increase:
            return Observable.just(Mutation.increaseValue)
        case .decrease:
            return Observable.just(Mutation.increaseValue)
        }
    }

       // Mutation -> State
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setValue(let value):
            state.value = value
        case .increaseValue:
           state.value += 1
        case .decreaseValue:
           state.value -= 1
        }
        return state
    }
}

