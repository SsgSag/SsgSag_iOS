//
//  MyClubComment.swift
//  SsgSag
//
//  Created by bumslap on 08/03/2020.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation

struct MyClubCommentResponsee: Codable {
    let status: Int?
    let message: String?
    let data: [MyClubComment]?
}

struct MyClubComment: Codable {
    let clubIdx: Int
    let clubName: String?
    let clubPostIdx: Int?
    let clubType: Int?
    let clubStartDate: String?
    let clubEndDate: String?
    let oneLine: String?
    let advantage: String?
    let disadvantage: String?
    let honeyTip: String?
    let score0, score1, score2, score3, score4: Int?
    let userIdx: Int?
    let regDate: String?
    let adminAccept: Int?
    let isMine: Int?
    let isLike: Int?
    let likeNum: Int?
    let userNickname:String?
}
