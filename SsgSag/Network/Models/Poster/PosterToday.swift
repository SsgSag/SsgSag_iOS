//
//  PosterToday.swift
//  SsgSag
//
//  Created by on 21/02/2020.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation

struct PosterTodayResponse: Codable {
    let status: Int?
    let message: String?
    let data: PosterToday?
}

// MARK: - DataClass

struct PosterToday: Codable {
    let ssgSummaryPosterList: [SummaryPoster]?
    let sagSummaryPosterList: [SummaryPoster]?
}
struct SummaryPoster: Codable {
    let posterIdx, categoryIdx: Int?
    let subCategoryIdx: Int?
    let photoUrl: String?
    let thumbPhotoUrl: String?
    let posterName, posterRegDate, posterEndDate: String?
    let posterStartDate: String?
    let documentDate: String?
    let contentIdx, hostIdx: Int?
    let keyword: String?
    let favoriteNum, likeNum: Int?
    let dday: Int?
    let isFavorite: Int?
    let swipeNum: Int?
    let isSave: Int?
}
