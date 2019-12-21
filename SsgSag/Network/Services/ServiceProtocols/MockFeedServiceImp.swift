//
//  MockFeedServiceImp.swift
//  SsgSag
//
//  Created by 이혜주 on 11/11/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

class MockFeedServiceImp: FeedService {
    func requestFeedData(page: Int, completionHandler: @escaping (DataResponse<[FeedData]>) -> Void) {
        print("page: \(page)")
    }
    
    func requestScrapStore(feedIndex: Int, completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void) {
        
    }
    
    func requestScrapDelete(feedIndex: Int, completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void) {
        
    }
    
    func requestScrapList(page: Int, completionHandler: @escaping (DataResponse<[FeedData]>) -> Void) {
        
    }
    
    func requestFeedLookUp(posterIndex: Int, completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void) {
        
    }
    
    
}
