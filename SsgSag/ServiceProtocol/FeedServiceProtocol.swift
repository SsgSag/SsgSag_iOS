//
//  FeedServiceProtocol.swift
//  SsgSag
//
//  Created by 이혜주 on 02/08/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

protocol FeedService: class {
    // 피드 데이터 요청
    func requestFeedData(
        completionHandler: @escaping (DataResponse<[FeedData]>) -> Void
    )
    
    // 스크랩
    func requestScrapStore(
        feedIndex: Int,
        completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void
    )
    
    // 스크랩 취소
    func requestScrapDelete(
        feedIndex: Int,
        completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void
    )
    
    // 스크랩 목록 요청
    func requestScrapList(
        completionHandler: @escaping (DataResponse<[FeedData]>) -> Void
    )
    
    // 뉴스 조회 -> 서버에서 조회수 계산 위해서 사용합니다
    func requestFeedLookUp(
        posterIndex: Int,
        completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void
    )
}
