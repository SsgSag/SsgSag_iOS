//
//  PosterDetail.swift
//  SsgSag
//
//  Created by 이혜주 on 16/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

// MARK: - PosterDetail
struct PosterDetail: Codable {
    let status: Int
    let message: String
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    let posterIdx, categoryIdx: Int?
    let photoUrl: String?
    let posterName, posterRegDate, posterEndDate: String?
    let posterStartDate: String?
    let posterWebSite: String?
    let outline, target, benefit: String?
    let period: String?
    let documentDate: String?
    let contentIdx, hostIdx: Int?
    let posterDetail: String?
    let posterInterest: [Int]?
    let adminAccept: Int?
    let keyword: String?
    let partnerPhone, partnerEmail, chargerName: String?
    let favoriteNum, likeNum: Int?
    let analytics: String?
    let dday: Int?
}
