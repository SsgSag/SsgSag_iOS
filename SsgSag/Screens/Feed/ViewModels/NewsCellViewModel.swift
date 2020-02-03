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
    var dateString: String
    let viewCount: String
    let saveButtonImageName = BehaviorRelay<String>(value: "icBookmark")
    let feed: FeedData

    init(feed: FeedData) {
        self.dateString = ""
        self.feedService = FeedServiceTypeImp()
        self.newsImageUrl = feed.feedPreviewImgUrl ?? ""
        self.newsTitle = feed.feedName ?? ""
        self.source = feed.feedHost ?? ""
        
        self.viewCount = "\(feed.showNum ?? 0)"
        self.feed = feed

        if feed.isSave == 1 {
            saveButtonImageName.accept("icBookmarkActive")
        } else {
            saveButtonImageName.accept("icBookmark")
        }
        self.dateString = date(to: (feed.feedRegDate ?? ""))
    }
    
    func date(to calendarDate: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat =  "yyyy-MM-dd HH:mm:ss"
        if let date = formatter.date(from: calendarDate) {
            formatter.dateFormat =  "yyyy-MM-dd"
            let convertedStringDate = formatter.string(from: date)
            return convertedStringDate
        } else {
            return ""
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
