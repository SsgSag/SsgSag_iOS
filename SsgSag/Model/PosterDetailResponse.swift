//
//  PosterDetailResponse.swift
//  SsgSag
//
//  Created by admin on 30/04/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

struct PosterDetailResponse: Codable {
    let status: Int?
    let message: String?
    let data: posterDetail?
}

struct posterDetail: Codable {
    let posterIdx, categoryIdx: Int?
    let photoURL: String?
    let posterName, posterRegDate, posterStartDate, posterEndDate: String?
    let posterWebSite: String?
    let isSeek: Int?
    let outline, target, period, benefit: String?
    let documentDate: String?
    let contentIdx, hostIdx: Int?
    let posterDetail: String?
    let posterInterest: [Int]?
    let dday, adminAccept: Int?
    
    enum CodingKeys: String, CodingKey {
        case posterIdx, categoryIdx
        case photoURL = "photoUrl"
        case posterName, posterRegDate, posterStartDate, posterEndDate, posterWebSite, isSeek, outline, target, period, benefit, documentDate, contentIdx, hostIdx, posterDetail, posterInterest, dday, adminAccept
    }
}
