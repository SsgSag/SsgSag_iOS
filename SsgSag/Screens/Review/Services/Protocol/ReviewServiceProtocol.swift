//
//  ReviewServiceProtocol.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/07.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation

protocol ReviewServiceProtocol {
    func requestExistClubReviewPost(model: ClubActInfoModel, completion: @escaping (Bool) -> Void)
    func requestNonExistClubReviewPost(model: ClubActInfoModel, completion: @escaping (Bool) -> Void)
    func requestReviewList(clubIdx: Int, curPage: Int, completion: @escaping ([ReviewInfo]?) -> Void)
}
