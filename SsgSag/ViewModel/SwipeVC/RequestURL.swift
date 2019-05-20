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
    case registerInterestJobs
    case deleteAcitivity(careerIdx: Int)
    case subscribeInterest
    case subscribeAddOrDelete(interestIdx: Int)
    case signUp
    case isUpdate
    case career(careerType: Int)
    
    func getRequestURL() -> String {
        switch self {
        case .posterLiked(posterIdx: let posterIdx, likeType: let like):
            return "UserAPI/poster/like?posterIdx=\(posterIdx)&like=\(like)"
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
        case .registerInterestJobs:
            return "/user/reInterestReq2"
        case .deleteAcitivity(careerIdx: let careerIdx):
            return "/career/\(careerIdx)"
        case .subscribeInterest:
            return "/user/subscribe"
        case .subscribeAddOrDelete(let interestIdx):
            return "/user/subscribe/\(interestIdx)"
        case .signUp:
            return "/user"
        case .isUpdate:
            return "/update"
        case .career(careerType: let careerType):
            return "/career/\(careerType)"
        }
    }
    
}
