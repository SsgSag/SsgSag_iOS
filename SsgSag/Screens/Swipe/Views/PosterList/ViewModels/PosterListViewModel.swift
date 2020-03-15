//
//  PosterListViewModel.swift
//  SsgSag
//
//  Created by bumslap on 22/12/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

class PosterListViewModel {
    var categoryViewModel: PosterListCategoryViewModel = .init(headerTypes: [], titles: [], categories: [])
    let categoryType: TotalInfoCategoryType
    
    init(categoryType: TotalInfoCategoryType) {
        self.categoryType = categoryType
    }
    
    func create() {
        switch categoryType {
        case .contest:
            let types = InterestingFieldContest.allCases.map { $0.getTypeString() }
            self.categoryViewModel = PosterListCategoryViewModel(headerTypes: [], titles: types,
                                                                 categories: InterestingFieldContest.allCases.map { $0.rawValue })
            self.categoryViewModel.createSubViewModels()
            
        case .club:
            let types = InterstingClubType.allCases.map { $0.getTypeString() }
            self.categoryViewModel = PosterListCategoryViewModel(headerTypes: [.internalClub("교내"), .allClub("연합")],
                                                                 titles: types,
                                                                 categories: InterstingClubType.allCases.map { $0.rawValue })
            self.categoryViewModel.createSubViewModels()
        case .activity:
            let types = InterestingFieldActivity.allCases.map { $0.getTypeString() }
            self.categoryViewModel = PosterListCategoryViewModel(headerTypes: [], titles: types,
                                                                 categories: InterestingFieldActivity
                                                                    .allCases
                                                                    .map { if let type = Int($0.rawValue) {
                                                                            return type
                                                                    } else {
                                                                        return 251
                                                                    
                                                                    }
                                                                    
                })
            self.categoryViewModel.createSubViewModels()
        case .internship:
            let types = CompanyTypeInternShip.allCases.map { $0.getTypeString() }
            self.categoryViewModel = PosterListCategoryViewModel(headerTypes: [.internshipCompanyType("기업형태"), .internshipInteresting("관심직무")], titles: types,
                                                                 categories: CompanyTypeInternShip.allCases.map { $0.rawValue })
            self.categoryViewModel.createSubViewModels()
        default:
            self.categoryViewModel = PosterListCategoryViewModel(headerTypes: [], titles: [InterestingFieldInternShip.none.getTypeString()], categories: [0])
            self.categoryViewModel.createSubViewModels()
        }
    }
    
    func userPressedCategoryTitle(at indexPath: IndexPath) {
        categoryViewModel.userPressed(at: indexPath)
    }
}
