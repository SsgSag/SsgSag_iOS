//
//  RequestURL.swift
//  SsgSag
//
//  Created by admin on 21/04/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

enum RequestURL {
    case posterLiked(posterIdx: Int, likeType: Int)
    case initPoster
    case login
    case snsLogin
    case favorite(posterIdx: Int)
    case deletePoster(posterIdx: Int)
    case completeApply(posterIdx: Int)
    case allTodoList
    case posterDetail(posterIdx: Int)
    case interestingField
    case reIntersting
    case careerActivity
    
    func getRequestURL() -> String {
        switch self {
        case .posterLiked(posterIdx: let posterIdx, likeType: let like):
            return "/poster/like?posterIdx=\(posterIdx)&like=\(like)"
        case .initPoster:
            return "/poster/show"
        case .login:
            return "/login2"
        case .snsLogin:
            return "/login"
        case .favorite(posterIdx: let posterIdx):
            return "/todo/favorite/\(posterIdx)"
        case .deletePoster(posterIdx: let posterIdx):
            return "/todo/\(posterIdx)"
        case .completeApply(posterIdx: let posterIdx):
            return "/todo/complete/\(posterIdx)"
        case .allTodoList:
            return "/todo?year=0000&month=00&day=00"
        case .posterDetail(posterIdx: let posterIdx):
            return "/poster/\(posterIdx)"
        case .interestingField:
            return "/user/interest"
        case .reIntersting:
            return "/user/reInterestReq1"
        case .careerActivity:
            return "/career"
        }
    }
    
    
    
}
