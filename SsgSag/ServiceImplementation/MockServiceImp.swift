//
//  MockServiceImp.swift
//  SsgSag
//
//  Created by 이혜주 on 02/12/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class MockServiceImp: PosterService {
    
    let requestMaker: RequestMakerProtocol
    let network: Network
    
    init(requestMaker: RequestMakerProtocol,
         network: Network) {
        self.requestMaker = requestMaker
        self.network = network
    }
    
    func requestSwipePosters(completionHandler: @escaping (DataResponse<PosterData>) -> Void) {
        let poster = Posters.init(posterIdx: 1,
                                  categoryIdx: 0,
                                  subCategoryIdx: 0,
                                  photoUrl: "",
                                  posterName: "최신버전으로 업데이트해주세요",
                                  posterRegDate: "2019-01-22 00:35:49",
                                  posterStartDate: "2019-01-22 00:35:49",
                                  posterEndDate: "2019-02-11 23:59:59",
                                  posterWebSite: "www.s1-idea.co.kr",
                                  isSeek: 0,
                                  outline: "",
                                  target: "",
                                  period: "",
                                  benefit: "",
                                  documentDate: "23:59",
                                  contentIdx: 200,
                                  hostIdx: 20000,
                                  posterDetail: "detail",
                                  posterInterest: [0],
                                  dday: 0,
                                  adminAccept: 1,
                                  keyword: "해당 기능을 사용하려면 슥삭을 최신버전으로 업데이트해주세요:D",
                                  favoriteNum: 0,
                                  likeNum: 4)
        
        let posterData = PosterData.init([poster], 0)
        completionHandler(.success(posterData))
    }
    
    func requestPosterStore(of posterIdx: Int,
                            type likedCategory: likedOrDisLiked,
                            completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void) {
        
    }
    
    func requestPosterDetail(posterIdx: Int,
                             completionHandler: @escaping (DataResponse<DataClass>) -> Void) {
        
    }
    
    func requestPosterFavorite(index: Int,
                               method: HTTPMethod,
                               completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void) {
        
    }
    
    func requestAllPosterAfterSwipe(category: Int,
                                    sortType: Int,
                                    completionHandler: @escaping (DataResponse<[PosterDataAfterSwpie]>) -> Void) {
        
    }
}

