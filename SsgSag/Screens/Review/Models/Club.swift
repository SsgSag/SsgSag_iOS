//
//  Club.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/27.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation

struct Club: Codable {
    let status: Int?
    let message: String?
    let data: [ClubListData]?
}

struct ClubListData: Codable {
    let clubIdx: Int
    let clubName, clubType, categoryList, oneLine: String
    let score0sum, scoreNum: Int
    let aveScore: Float
}
