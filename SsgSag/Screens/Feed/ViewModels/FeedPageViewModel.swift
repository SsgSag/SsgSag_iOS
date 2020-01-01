//
//  FeedPageViewModel.swift
//  SsgSag
//
//  Created by bumslap on 29/12/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class FeedPageViewModel {
    let feedService: FeedServiceProtocolType
    let pageType: FeedPageType
    let isLoading: BehaviorRelay = BehaviorRelay<Bool>(value: false)
    
    let newsCellViewModels = BehaviorRelay<[NewsCellViewModel]>(value: [])
    
    var currentFeedPageNumber = 0
    
    init(type: FeedPageType, service: FeedServiceProtocolType = FeedServiceTypeImp()) {
        self.pageType = type
        self.feedService = service
    }
    
    deinit {
        debugPrint("deinit: FeedPageViewModel deinited")
    }
    
    func fetchFeedPage() -> Observable<[FeedData]> {
       return feedService
        .requestFeedData(page: currentFeedPageNumber)
        .filter { $0.count > 0 }
        .flatMapLatest { [weak self] (feeds) -> Observable<[FeedData]> in
            self?.currentFeedPageNumber += 1
            return .just(feeds)
        }
    }
    
    func fetchScrapedFeedPage() -> Observable<[FeedData]> {
       return feedService
        .requestScrapList(page: currentFeedPageNumber)
        .filter { $0.count > 0 }
        .flatMapLatest { [weak self] (feeds) -> Observable<[FeedData]> in
            self?.currentFeedPageNumber += 1
            debugPrint("count: \(self?.currentFeedPageNumber)")
            return .just(feeds)
        }
    }

}
