//
//  PosterListCategoryCollectionViewCellViewModel.swift
//  SsgSag
//
//  Created by bumslap on 22/12/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PosterListCategoryCollectionViewCellViewModel {
    let title: String
    let titleColor = BehaviorRelay<UIColor>(value: .unselectedTextGray)
    
    init(title: String) {
        self.title = title
    }
}
