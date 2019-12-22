//
//  PosterListViewModel.swift
//  SsgSag
//
//  Created by bumslap on 22/12/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

class PosterListViewModel {
    var categoryViewModel: PosterListCategoryViewModel = .init(titles: [], categories: [])
    let categoryType: TotalInfoCategoryType
    
    init(categoryType: TotalInfoCategoryType) {
        self.categoryType = categoryType
    }
    
    func create() {
        switch categoryType {
        case .contest:
            let types = InterestingFieldContest.allCases.map { $0.getTypeString() }
            self.categoryViewModel = PosterListCategoryViewModel(titles: types,
                                                                 categories: InterestingFieldContest.allCases.map { $0.rawValue })
            self.categoryViewModel.createSubViewModels()
        case .activity:
            let types = InterestingFieldActivity.allCases.map { $0.getTypeString() }
            self.categoryViewModel = PosterListCategoryViewModel(titles: types,
                                                                 categories: InterestingFieldActivity.allCases.map { $0.rawValue })
            self.categoryViewModel.createSubViewModels()
        case .internship:
            let types = InterestingFieldInternShip.allCases.map { $0.getTypeString() }
            self.categoryViewModel = PosterListCategoryViewModel(titles: types,
                                                                 categories: InterestingFieldInternShip.allCases.map { $0.rawValue })
            self.categoryViewModel.createSubViewModels()
        default:
            self.categoryViewModel = PosterListCategoryViewModel(titles: [InterestingFieldInternShip.none.getTypeString()], categories: [0])
            self.categoryViewModel.createSubViewModels()
        }
    }
    
    func userPressedCategoryTitle(at indexPath: IndexPath) {
        categoryViewModel.userPressed(at: indexPath)
    }
}
