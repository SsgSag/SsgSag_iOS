//
//  FeedServiceProtocol.swift
//  SsgSag
//
//  Created by bumslap on 29/12/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation
import RxSwift

protocol FeedServiceProtocolType: class {
    // 피드 데이터 요청
    func requestFeedData(page: Int) -> Observable<[FeedData]>
    
    // 스크랩
    func requestScrapStore(feedIndex: Int) -> Observable<DataResponse<HttpStatusCode>>
    
    // 스크랩 취소
    func requestScrapDelete(feedIndex: Int) -> Observable<DataResponse<HttpStatusCode>>
    
    // 스크랩 목록 요청
    func requestScrapList(page: Int) -> Observable<[FeedData]>
    
    // 뉴스 조회 -> 서버에서 조회수 계산 위해서 사용합니다
    func requestFeedLookUp(posterIndex: Int) -> Observable<DataResponse<HttpStatusCode>>
    
}
