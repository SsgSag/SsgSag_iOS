//
//  FeedViewModel.swift
//  SsgSag
//
//  Created by bumslap on 29/12/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

class FeedViewModel {
    let pageViewModels: [FeedPageViewModel]
    
    init() {
        pageViewModels = FeedPageType.allCases.map { FeedPageViewModel(type: $0) }
    }
}
