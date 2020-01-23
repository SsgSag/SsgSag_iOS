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

typealias FilterSectionModel = SectionModel<String, MyFilterCollectionViewCellReactor>

class MyFilterSettingViewReactor: Reactor {
    
    var buttonCellViewReactors: [[MyFilterButtonCollectionViewCellReactor]] = []
    var sliderCellViewReactor: MyFilterSliderCollectionViewCellReactor

    let service: MyFilterApiService = MyFilterApiServiceImp()
    
    enum Action {
        case save
        case update(IndexPath, Int?)
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
        var jobKind: [String]
        var interestedField: [String]
        var maxGrade: Int
        var headers: [MyFilterHeader]
        var myFilterSetting: MyFilterSetting
        var selectedJobKindsIndexies: [Int]
        var numberOfSelectedJobkind: Int = 1
        var isLoading: Bool = false
    }

    let initialState: State
    
    init(jobKind: [String],
         interestedField: [String],
         maxGrade: Int, initialSetting: MyFilterSetting) {
        let headers = [
            MyFilterHeader(title: "희망 직무",
                           description: "직무에 맞는 필요한 정보를 추천해드려요."),
            MyFilterHeader(title: "관심 분야",
                           description: "관심 분야에 따라 맞는 필요한 정보를 추천해드려요."),
            MyFilterHeader(title: "학년",
                           description: "시기 별로 필요한 정보를 추천해드려요.")
        ]

        
        let jobKindCellReactors = jobKind.enumerated().map {
            MyFilterButtonCollectionViewCellReactor(titleText: $0.element,
                                                    isSelected: initialSetting.jobKind.contains($0.element),
                                                    indexPath: IndexPath(item: $0.offset, section: 0))
              }
              
        let interestedFieldCellReactors = interestedField.enumerated().map {
            MyFilterButtonCollectionViewCellReactor(titleText: $0.element,
                                                    isSelected: initialSetting.interestedField.contains($0.element),
                                                    indexPath: IndexPath(item: $0.offset, section: 1))
              }

        let sliderCellReactor = MyFilterSliderCollectionViewCellReactor(maxValue: maxGrade,
                                                                        currentValue: initialSetting.grade)
        self.buttonCellViewReactors = [jobKindCellReactors, interestedFieldCellReactors]
        self.sliderCellViewReactor = sliderCellReactor
        
        
        let selectedIndex = jobKind
            .enumerated()
            .filter { initialSetting.jobKind.contains($0.element) }
            .map { $0.offset }
   
        let observableSections: [SectionModel<String, MyFilterCollectionViewCellReactor>] = [
            SectionModel(model: "jobKind", items: buttonCellViewReactors[0]),
            SectionModel(model: "interestedField", items: buttonCellViewReactors[1]),
            SectionModel(model: "grade", items: [sliderCellViewReactor])
        ]

        self.initialState = State(observableSections: observableSections, sections: [
            jobKind, interestedField, Array(1...maxGrade).map { "\($0)" }
            ],
                                  jobKind: jobKind,
                                  interestedField: interestedField,
                                  maxGrade: maxGrade,
                                  headers: headers,
                                  myFilterSetting: initialSetting,
                                  selectedJobKindsIndexies: selectedIndex, numberOfSelectedJobkind: 1, isLoading: false) //numberOfSelectedJobkind 임시로 추가했습니다.
        
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .update(let updateValue):
            let newSetting = makeNewSetting(with: updateValue.0, grade: updateValue.1)
            if currentState.myFilterSetting.jobKind.count < 2
                && updateValue.0.section == 0 {
                if newSetting.jobKind.count > currentState.myFilterSetting.jobKind.count {
                    return Observable.just(Mutation.updateSetting(newSetting))
                } else {
                    return Observable.just(Mutation.updateSetting(currentState.myFilterSetting))
                }
            } else {
                 return Observable.just(Mutation.updateSetting(newSetting))
            }
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
    
    private func makeNewSetting(with indexPath: IndexPath, grade: Int? = nil) -> MyFilterSetting {
        let oldSetting = currentState.myFilterSetting
        let section = Section(at: indexPath)
        var mutableArray = [String]()
        if let grade = grade {
            let newSetting = MyFilterSetting(jobKind: oldSetting.jobKind,
                                                        interestedField: oldSetting.interestedField,
                                                        grade: grade)
            return newSetting
        } else {
            switch section {
            case .jobKind:
                let settingTitle = currentState.sections[section.rawValue][indexPath.item]
                if oldSetting.jobKind.contains(settingTitle) {
                    mutableArray = oldSetting.jobKind.filter { $0 != settingTitle }
                } else {
                    mutableArray.append(contentsOf: oldSetting.jobKind)
                    mutableArray.append(settingTitle)
                }
                let newSetting = MyFilterSetting(jobKind: mutableArray,
                                                 interestedField: oldSetting.interestedField,
                                                 grade: oldSetting.grade)
                return newSetting
            case .interestedField:
                let settingTitle = currentState.sections[section.rawValue][indexPath.item]
                if oldSetting.interestedField.contains(settingTitle) {
                    mutableArray = oldSetting.interestedField.filter { $0 != settingTitle }
                } else {
                    mutableArray.append(contentsOf: oldSetting.interestedField)
                    mutableArray.append(settingTitle)
                }
                let newSetting = MyFilterSetting(jobKind: oldSetting.jobKind,
                                                 interestedField: mutableArray,
                                                 grade: oldSetting.grade)
                return newSetting
            case .userGrade:
                return oldSetting
            }
        }
    }
}
