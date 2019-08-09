//
//  CommentService.swift
//  SsgSag
//
//  Created by 이혜주 on 09/08/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

protocol CommentService: class {
    func requestAddComment(
        index: Int,
        comment: String,
        completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void
    )
    
    func requestCommentLike(
        index: Int,
        like: Int,
        completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void
    )
    
    func requestCommentDelete(
        index: Int,
        completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void
    )
    
    func requestCommentReport(
        index: Int,
        completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void
    )
}
