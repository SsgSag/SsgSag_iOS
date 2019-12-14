//
//  TotalInformationTableViewCellReactor.swift
//  SsgSag
//
//  Created by bumslap on 08/12/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation
import RxSwift
import ReactorKit

class TotalInformationTableViewCellReactor: Reactor {
    enum Action {
        case set(String)
        case moreButtonTapped
    }

    enum Mutation {
        case setTitle(String)
    }

     struct State {
        var title: String = ""
        var type: TotalInfoCategoryType
        var items: [TotalInformation]
     }

    let initialState: State
    
    init(type: TotalInfoCategoryType, items: [TotalInformation]) {
        self.initialState = State(type: type, items: items)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .set(let title):
            let type = currentState.type
            var activityTypeString = ""
            switch type {
            case .contest:
                activityTypeString = "공모전 뭐 하지?"
            case .activity:
                activityTypeString = "대외활동 뭐 하지?"
            case .internship:
                activityTypeString = "인턴 뭐 하지?"
            case .etc:
                activityTypeString = "기타 뭐 하지?"
            case .lecture:
                activityTypeString = "교육/강연 뭐 하지?"
            }
            return Observable.just(Mutation.setTitle(activityTypeString))
        case .moreButtonTapped:
            return .empty()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setTitle(let title):
            state.title = title
        }
        return state
    }
}
