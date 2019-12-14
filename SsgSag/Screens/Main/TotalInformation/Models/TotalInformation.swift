//
//  TotalInformation.swift
//  SsgSag
//
//  Created by bumslap on 07/12/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

struct TotalInformationResponse: Decodable {
    let status: Int?
    let message: String?
    let data: [TotalInformation]?
}

struct TotalInformation: Decodable {
    
    let posterIdx: Int?
    let categoryIdx: Int?
    let subCategoryIdx: Int?
    let photoUrl: String?
    let thumbPhotoUrl: String?
    let posterName: String?
    let posterRegDate: String?
    let posterStartDate: String?
    let posterEndDate: String?
    let documentDate: String?
    let contentIdx: Int?
    let keyword: String?
    let favoriteNum: Int?
    let likeNum: Int?
    let swipeNum: Int?
    let isSave: Int?
    let dday: Int?
    
    init(posterIdx: Int? = nil,
         categoryIdx: Int? = nil,
         subCategoryIdx: Int? = nil,
         photoUrl: String? = nil,
         thumbPhotoUrl: String? = nil,
         posterName: String? = nil,
         posterRegDate: String? = nil,
         posterStartDate: String? = nil,
         posterEndDate: String? = nil,
         documentDate: String? = nil,
         contentIdx: Int? = nil,
         keyword: String? = nil,
         favoriteNum: Int? = nil,
         likeNum: Int? = nil,
         swipeNum: Int? = nil,
         isSave: Int?,
         dday: Int? = nil) {
        self.posterIdx = posterIdx
        self.categoryIdx = categoryIdx
        self.subCategoryIdx = subCategoryIdx
        self.photoUrl = photoUrl
        self.thumbPhotoUrl = thumbPhotoUrl
        self.posterName = posterName
        self.posterRegDate = posterRegDate
        self.posterStartDate = posterStartDate
        self.posterEndDate = posterEndDate
        self.documentDate = documentDate
        self.contentIdx = contentIdx
        self.keyword = keyword
        self.favoriteNum = favoriteNum
        self.likeNum = likeNum
        self.swipeNum = swipeNum
        self.isSave = isSave
        self.dday = dday
    }
    
    init() {
        self.posterIdx = nil
        self.categoryIdx = nil
        self.subCategoryIdx = nil
        self.photoUrl = nil
        self.thumbPhotoUrl = nil
        self.posterName = nil
        self.posterRegDate = nil
        self.posterStartDate = nil
        self.posterEndDate = nil
        self.documentDate = nil
        self.contentIdx = nil
        self.keyword = nil
        self.favoriteNum = nil
        self.likeNum = nil
        self.swipeNum = nil
        self.isSave = nil
        self.dday = nil
    }
    
}
