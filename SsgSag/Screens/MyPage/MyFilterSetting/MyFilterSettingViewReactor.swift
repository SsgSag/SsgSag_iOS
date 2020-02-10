//
//  MyFilteringReactor.swift
//  SsgSag
//
//  Created by bumslap on 23/11/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import ReactorKit

protocol MyFilterCollectionViewCellReactor {}

private enum Section: Int {
    case myInfo
    case interestedField
    case interestedJob
    
    init(section: Int) {
        self = Section(rawValue: section)!
    }
    
    init(at indexPath: IndexPath) {
        self = Section(rawValue: indexPath.section)!
    }
}

typealias FilterSectionModel = SectionModel<String, MyFilterCollectionViewCellReactor>

class MyFilterSettingViewReactor: Reactor {
    
    var buttonCellViewReactors: [[MyFilterButtonCollectionViewCellReactor]] = []

    let myFilterService: MyFilterApiService = MyFilterApiServiceImp()
    let userInfoService: UserInfoService = UserInfoServiceImp()
    
    enum Action {
        case save
        case update(IndexPath)
    }

    enum Mutation {
        case addSeletedItem(Int)
        case deleteSelectedItem(Int)
        case updateSetting(MyFilterSetting)
        case setLoading(Bool)
    }

    struct State {
        var observableSections: [SectionModel<String, MyFilterCollectionViewCellReactor>]
        var sections: [[String]] = []
        var myInfo: [String]
        var interestedField: [String]
        var headers: [MyFilterHeader]
        var myFilterSetting: MyFilterSetting
        var selectedJobKindsIndexies: [Int]
        var numberOfSelectedJobkind: Int = 1
        var isLoading: Bool = false
    }

    let initialState: State
    
    init(myInfo: [String],
         interestedField: [String],
         interestedJob: [String],
         initialSetting: MyFilterSetting) {
        let headers = [
            MyFilterHeader(title: "학교/학과",
                           description: ""),
            MyFilterHeader(title: "관심 분야",
                           description: "조금이라도 관심있는 분야를 모두 골라주세요!"),
            MyFilterHeader(title: "관심 직무",
                           description: "나와 같은 관심직무를 가진 친구/선배들을 분석하여 정보를 추천해드려요!")
        ]

        
        let myInfoCellReactors = myInfo.enumerated().map {
            MyFilterButtonCollectionViewCellReactor(titleText: $0.element,
                                                    isSelected: true,
                                                    indexPath: IndexPath(item: $0.offset, section: 0))
              }
              
        let interestedFieldCellReactors = interestedField.enumerated().map {
            MyFilterButtonCollectionViewCellReactor(titleText: $0.element,
                                                    isSelected: initialSetting.interestedField.contains($0.element),
                                                    indexPath: IndexPath(item: $0.offset, section: 1))
              }

        let interestedJobCellReactors = interestedJob.enumerated().map {
        MyFilterButtonCollectionViewCellReactor(titleText: $0.element,
                                                isSelected: initialSetting.interestedJob.contains($0.element),
                                                indexPath: IndexPath(item: $0.offset, section: 1))
          }
        
        self.buttonCellViewReactors = [myInfoCellReactors,
                                       interestedFieldCellReactors,
                                       interestedJobCellReactors]
        
        
        let selectedIndex = interestedJob
            .enumerated()
            .filter { initialSetting.interestedJob.contains($0.element) }
            .map { $0.offset }
   
        let observableSections: [SectionModel<String, MyFilterCollectionViewCellReactor>] = [
            SectionModel(model: "myInfo", items: buttonCellViewReactors[0]),
            SectionModel(model: "interestedField", items: buttonCellViewReactors[1]),
            SectionModel(model: "interestedFieldJob", items: buttonCellViewReactors[2])
        ]

        self.initialState = State(observableSections: observableSections, sections: [
            myInfo, interestedField, interestedJob
            ],
                                  myInfo: myInfo,
                                  interestedField: interestedField,
                                  headers: headers,
                                  myFilterSetting: initialSetting,
                                  selectedJobKindsIndexies: selectedIndex,
                                  numberOfSelectedJobkind: 1,
                                  isLoading: false) //numberOfSelectedJobkind 임시로 추가했습니다.
        
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .update(let updateValue):
            let newSetting = makeNewSetting(with: updateValue)
                return Observable.just(Mutation.updateSetting(newSetting))
        case .save:
            guard !self.currentState.isLoading else { return Observable.empty() }
            return Observable.empty()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .updateSetting(let setting):
            state.myFilterSetting = setting
        case .addSeletedItem(let index):
            state.selectedJobKindsIndexies.append(index)
        case .deleteSelectedItem(let index):
            state.selectedJobKindsIndexies = state.selectedJobKindsIndexies.filter {
                $0 != index
            }
        case .setLoading(let isLoading):
            state.isLoading = isLoading
        }
        return state
    }
    
    private func makeNewSetting(with indexPath: IndexPath) -> MyFilterSetting {
        let oldSetting = currentState.myFilterSetting
        let section = Section(at: indexPath)
        var mutableArray = [String]()
            switch section {
            case .myInfo:
                return oldSetting
            case .interestedField:
                let settingTitle = currentState.sections[section.rawValue][indexPath.item]
                if oldSetting.interestedField.contains(settingTitle) {
                    mutableArray = oldSetting.interestedField.filter { $0 != settingTitle }
                } else {
                    mutableArray.append(contentsOf: oldSetting.interestedField)
                    mutableArray.append(settingTitle)
                }
                let newSetting = MyFilterSetting(myInfo: oldSetting.myInfo,
                                                 interestedField: mutableArray,
                                                 interestedJob: oldSetting.interestedJob)
                return newSetting
            case .interestedJob:
                let settingTitle = currentState.sections[section.rawValue][indexPath.item]
                if oldSetting.interestedJob.contains(settingTitle) {
                    mutableArray = oldSetting.interestedJob.filter { $0 != settingTitle }
                } else {
                    mutableArray.append(contentsOf: oldSetting.interestedJob)
                    mutableArray.append(settingTitle)
                }
                let newSetting = MyFilterSetting(myInfo: oldSetting.myInfo,
                                                 interestedField: oldSetting.interestedField,
                                                 interestedJob: mutableArray)
                return newSetting
                
            }
    }
}
