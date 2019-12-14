//
//  TotalInformationReactor.swift
//  SsgSag
//
//  Created by bumslap on 07/12/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import RxSwift
import ReactorKit

class TotalInformationReactor: Reactor {
    
    private let service: TotalInformationServiceProtocol = TotalInformationService()
    
    enum Action {
        case loadItems
    }

    enum Mutation {
        case setItems([(key: TotalInfoCategoryType, value: [TotalInformation])])
        case setLoading(Bool)
    }

     struct State {
        var currentItems: [(key: TotalInfoCategoryType, value: [TotalInformation])] = []
        var isLoading: Bool = false
     }

    let initialState: State
    
    init() {
        self.initialState = State()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadItems:
            guard !currentState.isLoading else { return .empty() }
            let setItemsMutation = service.fetchAllTotalInformations(categories: TotalInfoCategoryType.allCases).map { (dict) -> TotalInformationReactor.Mutation in
                let sortedInfos = dict
                    .sorted { prevDict, currentDict in
                        prevDict.key.rawValue > currentDict.key.rawValue
                }
                .filter { !$0.value.isEmpty}
                return Mutation.setItems(sortedInfos)
                }
            return Observable.concat([.just(Mutation.setLoading(true)),
                                      setItemsMutation,
                                      .just(Mutation.setLoading(false))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setItems(let items):
            state.currentItems = items
        case .setLoading(let isLoading):
            state.isLoading = isLoading
        }
        return state
    }
}
