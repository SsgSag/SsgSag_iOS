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
    let status: Int?
    let message: String?
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    let posterIdx, categoryIdx: Int?
    let subCategoryIdx: Int?
    let photoUrl: String?
    let photoUrl2: String?
    let posterName, posterRegDate, posterEndDate: String?
    let posterStartDate: String?
    let posterWebSite: String?
    let posterWebSite2: String?
    let outline, target, benefit: String?
    let period: String?
    let documentDate: String?
    let contentIdx, hostIdx: Int?
    let posterDetail: String?
    let posterInterest: [Int]?
    let adminAccept: Int?
    let keyword: String?
    let partnerEmail, chargerName: String?
    let favoriteNum, likeNum: Int?
    let dday: Int?
    let analytics: Analytics?
    let commentList: [CommentList]?
    let isFavorite: Int?
}

// MARK: - Analytics
struct Analytics: Codable {
    let majorCategory: [String?]?
    let majorCategoryRate: [Int?]?
    let grade: [String?]?
    let gradeRate: [Int?]?
    let gender: [String?]?
    let genderRate: [Int?]?
}

// MARK: - CommentList
struct CommentList: Codable {
    let commentIdx, userIdx: Int?
    let userNickname: String?
    let userProfileUrl: String?
    let commentContent, commentRegDate: String?
    let likeNum, isLike, isMine: Int?
}
