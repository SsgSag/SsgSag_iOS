//
//  Review.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/29.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation


struct ReviewCellInfo {
    var data: ReviewInfo!
    var onClick = false
}

struct ReviewInfo: Codable {
    let clubPostIdx: Int
    let clubStartDate, clubEndDate: String
    let score0, score1, score2, score3, score4: Int
    let oneLine, advantage, disadvantage, honeyTip, regDate: String
    var userIdx, isMine, isLike, likeNum: Int
    let userNickname: String?
    let adminAccept: Int?
}

struct ReviewRegister: Codable {
    let clubIdx: Int
    let event: Bool
}
