//
//  PosterAfterSwipe.swift
//  SsgSag
//
//  Created by 이혜주 on 24/09/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

// MARK: - PosterAfterSwipe
struct PosterAfterSwipe: Codable {
    let status: Int?
    let message: String?
    let data: [PosterDataAfterSwpie]?
}

// MARK: - Datum
struct PosterDataAfterSwpie: Codable {
    let posterIdx, categoryIdx, subCategoryIdx: Int?
    let photoUrl: String?
    let posterName, posterRegDate, posterStartDate, posterEndDate: String?
    let documentDate: String?
    let contentIdx: Int?
    let keyword: String?
    let favoriteNum, likeNum, swipeNum, isSave: Int?
    let dday: Int?
}
