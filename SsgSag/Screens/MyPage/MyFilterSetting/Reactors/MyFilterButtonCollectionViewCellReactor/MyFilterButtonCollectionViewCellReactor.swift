//
//  MyFilterButtonCollectionViewCellReactor.swift
//  SsgSag
//
//  Created by bumslap on 30/11/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import RxSwift
import ReactorKit

private enum Section: Int {
    case myInfo
    case interestedField
    case interestedJob
    case interestedJobField
    
    init(section: Int) {
        self = Section(rawValue: section)!
    }
    
    init(at indexPath: IndexPath) {
        self = Section(rawValue: indexPath.section)!
    }
}

class MyFilterButtonCollectionViewCellReactor: Reactor, MyFilterCollectionViewCellReactor {
    enum Action {
        case set
        case userPressed(IndexPath, Int)
    }

    enum Mutation {
        case setBackgroundColor(UIColor)
        case setTextColor(UIColor)
        case setSelected(Bool)
        case empty
    }

    struct State {
        var backgroundColor: UIColor
        var textColor: UIColor
        var titleText: String
        var isSelected: Bool
        var indexPath: IndexPath
    }
       
    let initialState: State

    init(titleText: String, isSelected: Bool, indexPath: IndexPath) {
        if indexPath.section > 1 {
            
        }
        let editedTitleText = indexPath.section > 0 ? "#\(titleText)" : titleText
        self.initialState = State(backgroundColor: UIColor.greyFour,
                                  textColor: UIColor.greyThree,
                                  titleText: editedTitleText,
                                  isSelected: isSelected,
                                  indexPath: indexPath)
       }

          // Action -> Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .set:
            if currentState.isSelected {
                return Observable.concat([
                    Observable.just(Mutation.setBackgroundColor(.cornFlowerLight)),
                    Observable.just(Mutation.setTextColor(.white))
                ])
            } else {
                return Observable.just(Mutation.empty)
            }
        case .userPressed(let eventValue):
            let section = Section(at: eventValue.0)
            switch section {
            case .myInfo:
                return Observable.just(Mutation.empty)
            case .interestedField, .interestedJob, .interestedJobField:
                var backgroundColor: UIColor = .greyFour
                var textColor: UIColor = .greyThree
                if currentState.isSelected {
                    backgroundColor = .greyFour
                    textColor = .greyThree
                } else {
                    backgroundColor = .cornFlowerLight
                    textColor = .white
                }
                return Observable.concat([
                    Observable.just(Mutation.setSelected(!currentState.isSelected)),
                    Observable.just(Mutation.setBackgroundColor(backgroundColor)),
                    Observable.just(Mutation.setTextColor(textColor))
                ])
            }
        }
    }

          // Mutation -> State
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setBackgroundColor(let color):
            state.backgroundColor = color
        case .setTextColor(let color):
            state.textColor = color
        case .setSelected(let isSelected):
            state.isSelected = isSelected
        case .empty:
            break
        }
        return state
    }
}
