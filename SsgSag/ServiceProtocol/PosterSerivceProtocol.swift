//
//  PosterSerivceProtocol.swift
//  SsgSag
//
//  Created by 이혜주 on 27/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

protocol PosterService: class {
    // swipe화면에 보여질 poster들 요청
    func requestSwipePosters(
        completionHandler: @escaping (DataResponse<PosterData>) -> Void
    )
    
    // poster 캘린더에 저장
    func requestPosterStore(
        of posterIdx: Int,
        type likedCategory: likedOrDisLiked,
        completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void
    )
    
    // poster의 상세정보를 가져옵니다.
    func requestPosterDetail(
        posterIdx: Int,
        completionHandler: @escaping (DataResponse<DataClass>) -> Void
    )
    
    // poster 즐겨찾기 또는 즐겨찾기 해제
    func requestPosterFavorite(
        index: Int,
        method: HTTPMethod,
        completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void
    )
    
    // 모든 포스터 요청
    func requestAllPosterAfterSwipe(
        category: Int,
        sortType: Int,
        completionHandler: @escaping (DataResponse<[PosterDataAfterSwpie]>) -> Void
    )
}
