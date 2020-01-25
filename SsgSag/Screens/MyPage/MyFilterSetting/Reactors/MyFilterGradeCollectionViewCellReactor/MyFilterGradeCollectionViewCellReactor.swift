//
//  MyFilterGradeCollectionViewCellReactor.swift
//  SsgSag
//
//  Created by bumslap on 29/11/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import RxSwift
import ReactorKit

class MyFilterGradeCollectionViewCellReactor: Reactor {
    enum Action {
        case select(Int)
     }

    enum Mutation {
        case setSelected(Bool)
        case setTextColor(UIColor)
        case setTextFont(UIFont)
     }

    struct State {
        var gradeTextColor: UIColor
        var gradeText: String
        var index: Int
        var isSelected: Bool
        var textFont: UIFont
     }
    
    let initialState: State

    init(gradeText: String, isSelected: Bool, index: Int) {
        let gradeTextColor: UIColor = isSelected ? .cornFlower : .unselectedTextGray
        let gradeTextFont: UIFont = isSelected ? UIFont.systemFont(ofSize: 16, weight: .bold) : UIFont.systemFont(ofSize: 16, weight: .regular)
        self.initialState = State(gradeTextColor: gradeTextColor,
                                  gradeText: gradeText,
                                  index: index,
                                  isSelected: isSelected, textFont: gradeTextFont)
    }

       // Action -> Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .select(let value):
            let font: UIFont = value == self.currentState.index ? UIFont.systemFont(ofSize: 16, weight: .bold) : UIFont.systemFont(ofSize: 16, weight: .regular)
            let color: UIColor = value == self.currentState.index ? .cornFlower : .unselectedTextGray
            return Observable.concat([
                Observable.just(Mutation.setTextColor(color)),
                 Observable.just(Mutation.setTextFont(font))
            ])
                
               
        }
    }

       // Mutation -> State
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setSelected(let isSelected):
            state.isSelected = isSelected
        case .setTextColor(let color):
            state.gradeTextColor = color
        case .setTextFont(let font):
            state.textFont = font
        }
        return state
    }
}
