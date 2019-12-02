//
//  MyFilterButtonCollectionViewCellReactor.swift
//  SsgSag
//
//  Created by bumslap on 30/11/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation
import RxSwift
import ReactorKit

private enum Section: Int {
    case jobKind
    case interestedField
    case userGrade
    
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
        case setBorderColor(UIColor)
        case setTextColor(UIColor)
        case setSelected(Bool)
        case empty
    }

    struct State {
        var borderColor: UIColor
        var textColor: UIColor
        var titleText: String
        var isSelected: Bool
        var indexPath: IndexPath
    }
       
    let initialState: State

    init(titleText: String, isSelected: Bool, indexPath: IndexPath) {
        self.initialState = State(borderColor: UIColor.unselectedBorderGray,
                                  textColor: UIColor.unselectedGray,
                                  titleText: titleText,
                                  isSelected: isSelected,
                                  indexPath: indexPath)
       }

          // Action -> Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .set:
            if currentState.isSelected {
                return Observable.concat([
                    Observable.just(Mutation.setBorderColor(.cornFlower)),
                    Observable.just(Mutation.setTextColor(.cornFlower))
                ])
            } else {
                return Observable.just(Mutation.empty)
            }
        case .userPressed(let eventValue):
            print("num: \(eventValue.1)")
            let section = Section(at: eventValue.0)
            switch section {
            case .jobKind:
                var borderColor: UIColor = .unselectedBorderGray
                var textColor: UIColor = .unselectedGray
                if currentState.isSelected {
                    guard eventValue.1 > 1 else {
                            return Observable.just(Mutation.empty)
                        }
                        borderColor = .unselectedBorderGray
                        textColor = .unselectedGray
                    return Observable.concat([
                        Observable.just(Mutation.setSelected(!currentState.isSelected)),
                        Observable.just(Mutation.setBorderColor(borderColor)),
                        Observable.just(Mutation.setTextColor(textColor))
                    ])
                } else {
                    borderColor = .cornFlower
                    textColor = .cornFlower
                    return Observable.concat([
                        Observable.just(Mutation.setSelected(!currentState.isSelected)),
                        Observable.just(Mutation.setBorderColor(borderColor)),
                        Observable.just(Mutation.setTextColor(textColor))
                    ])
                }
               
            case .interestedField:
                var borderColor: UIColor = .unselectedBorderGray
                var textColor: UIColor = .unselectedGray
                if currentState.isSelected {
                    borderColor = .unselectedBorderGray
                    textColor = .unselectedGray
                } else {
                    borderColor = .cornFlower
                    textColor = .cornFlower
                }
                return Observable.concat([
                    Observable.just(Mutation.setSelected(!currentState.isSelected)),
                    Observable.just(Mutation.setBorderColor(borderColor)),
                    Observable.just(Mutation.setTextColor(textColor))
                ])
            default:
                assertionFailure("can't handle")
                return Observable.just(Mutation.empty)
            }
        }
    }

          // Mutation -> State
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setBorderColor(let color):
            state.borderColor = color
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
