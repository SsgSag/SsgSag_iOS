//
//  PosterListCategoryViewModel.swift
//  SsgSag
//
//  Created by bumslap on 21/12/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

class PosterListCategoryViewModel {
    let titles: [String]
    let categories: [Int]
    var cellViewModels: [PosterListCategoryCollectionViewCellViewModel] = []
    
    init(titles: [String], categories: [Int]) {
        self.titles = titles
        self.categories = categories
    }
    
    func createSubViewModels() {
        self.cellViewModels = titles
            .map { PosterListCategoryCollectionViewCellViewModel(title: $0) }
        self.cellViewModels.first?.titleColor.accept(.cornFlower)
    }
    
    func userPressed(at indexPath: IndexPath) {
        cellViewModels.forEach { $0.titleColor.accept(.unselectedTextGray) }
        cellViewModels[indexPath.item].titleColor.accept(.cornFlower)
    }
}
