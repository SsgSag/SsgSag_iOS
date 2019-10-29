//
//  CommentService.swift
//  SsgSag
//
//  Created by 이혜주 on 09/08/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

protocol CommentService: class {
    // 댓글 등록
    func requestAddComment(
        index: Int,
        comment: String,
        completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void
    )
    
    // 댓글 좋아요 여부
    func requestCommentLike(
        index: Int,
        like: Int,
        completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void
    )
    
    // 댓글 삭제
    func requestCommentDelete(
        index: Int,
        completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void
    )
    
    // 댓글 신고
    func requestCommentReport(
        index: Int,
        completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void
    )
}
