//
//  NewsCellViewModel.swift
//  SsgSag
//
//  Created by bumslap on 30/12/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class NewsCellViewModel {
    
    private let feedService: FeedServiceProtocolType
    
    let newsImageUrl: String
    let newsTitle: String
    let source: String
    let dateString: String
    let viewCount: String
    let saveButtonImageName = BehaviorRelay<String>(value: "ic_bookmarkArticlePassive")
    let feed: FeedData

    init(feed: FeedData) {
        self.feedService = FeedServiceTypeImp()
        self.newsImageUrl = feed.feedPreviewImgUrl ?? ""
        self.newsTitle = feed.feedName ?? ""
        self.source = feed.feedHost ?? ""
        self.dateString = feed.feedRegDate ?? ""
        self.viewCount = "\(feed.showNum ?? 0)"
        self.feed = feed

        if feed.isSave == 1 {
            saveButtonImageName.accept("ic_bookmarkArticle")
        } else {
            saveButtonImageName.accept("ic_bookmarkArticlePassive")
        }
    }
    
    func saveBookmark() -> Observable<DataResponse<HttpStatusCode>> {
        guard let index = feed.feedIdx else { return .empty() }
        return feedService.requestScrapStore(feedIndex: index)
    }
    
    func deleteBookmark() -> Observable<DataResponse<HttpStatusCode>> {
        guard let index = feed.feedIdx else { return .empty() }
        return feedService.requestScrapDelete(feedIndex: index)
    }
}
