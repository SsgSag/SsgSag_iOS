//
//  ReviewService.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/07.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation

class ReviewService: ReviewServiceProtocol {
    func requestExistClubReviewPost(model: ClubActInfoModel) -> Bool {
        return false
    }
    
    func requestNonExistClubReviewPost(model: ClubActInfoModel) -> Bool {
        return false
    }
}
