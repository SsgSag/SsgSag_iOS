//
//  PosterSerivceProtocol.swift
//  SsgSag
//
//  Created by 이혜주 on 27/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

protocol PosterService: class {
    func requestPoster(
        completionHandler: @escaping (DataResponse<posterData>) -> Void
    )
    
    func requestPosterLiked(
        of poster: Posters,
        type likedCategory: likedOrDisLiked,
        completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void
    )
    
    func requestPosterDetail(
        posterIdx: Int,
        completionHandler: @escaping (DataResponse<DataClass>) -> Void
    )
    
    func requestPosterFavorite(
        index: Int,
        method: HTTPMethod,
        completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void
    )
}
