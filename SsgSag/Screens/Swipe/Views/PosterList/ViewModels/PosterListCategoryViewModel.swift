//
//  PosterListCategoryViewModel.swift
//  SsgSag
//
//  Created by bumslap on 21/12/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation
import RxCocoa

class PosterListCategoryViewModel {
    let headerCategories: [HeaderCategoryType]
    let titles: [String]
    let categories: [Int]
    
    let firstButtonBackgroundColor = BehaviorRelay<UIColor>(value: UIColor.cornFlower.withAlphaComponent(0.15))
    let firstButtonTitleColor = BehaviorRelay<UIColor>(value: .cornFlower)
    let secondButtonBackgroundColor = BehaviorRelay<UIColor>(value: .greyFive)
    let secondButtonTitleColor = BehaviorRelay<UIColor>(value: .greyThree)
    var currentHeaderType = BehaviorRelay<HeaderCategoryType?>(value: nil)
    var cellViewModels = BehaviorRelay<[PosterListCategoryCollectionViewCellViewModel]>(value: [])
    
    init(headerTypes: [HeaderCategoryType], titles: [String], categories: [Int]) {
        self.headerCategories = headerTypes
        self.titles = titles
        self.categories = categories
    }
    
    func createSubViewModels() {
        let items = titles
            .map { PosterListCategoryCollectionViewCellViewModel(title: $0) }
        self.cellViewModels.accept(items)
        self.cellViewModels.value.first?.titleColor.accept(.cornFlower)
    }
    
    func userPressed(at index: Int) {
        guard 0..<2 ~= index else { return }
        currentHeaderType.accept(headerCategories[safe: index])
        switch index {
        case 0:
            firstButtonTitleColor.accept(.cornFlower)
            firstButtonBackgroundColor.accept(UIColor.cornFlower.withAlphaComponent(0.15))
            secondButtonTitleColor.accept(.greyThree)
            secondButtonBackgroundColor.accept(.greyFive)
        default:
            firstButtonTitleColor.accept(.greyThree)
            firstButtonBackgroundColor.accept(.greyFive)
            secondButtonTitleColor.accept(.cornFlower)
            secondButtonBackgroundColor.accept(UIColor.cornFlower.withAlphaComponent(0.15))
        }
        guard let type = currentHeaderType.value else { return }
        switch type {
        case .internshipCompanyType:
            let items = CompanyTypeInternShip
                .allCases
                .map { $0.getTypeString() }
                .map { PosterListCategoryCollectionViewCellViewModel(title: $0) }
            self.cellViewModels.accept(items)
            self.cellViewModels.value.first?.titleColor.accept(.cornFlower)
        case .internshipInteresting:
            let items = InterestingFieldInternShip
                .allCases
                .map { $0.getTypeString() }
                .map { PosterListCategoryCollectionViewCellViewModel(title: $0) }
            self.cellViewModels.accept(items)
            self.cellViewModels.value.first?.titleColor.accept(.cornFlower)
        default:
            break
        }
        
    }
    
    func userPressed(at indexPath: IndexPath) {
        cellViewModels.value.forEach { $0.titleColor.accept(.unselectedTextGray) }
        cellViewModels.value[indexPath.item].titleColor.accept(.cornFlower)
    }
}
