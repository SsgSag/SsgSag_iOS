//
//  Club.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/27.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation

enum ClubType: String {
    case Union = "0"
    case School = "1"
}

// 동아리 리스트
struct Clubs: Codable {
    let status: Int?
    let message: String?
    let data: [ClubListData]?
}

struct ClubListData: Codable {
    let clubIdx: Int
    let clubName: String
    let clubType: Int
    let categoryList, oneLine: String
    let score0sum, scoreNum: Int
    let aveScore: Float
}

// 동아리 상세
struct Club: Codable {
    let status: Int
    let message: String?
    let data: ClubInfo?
}

struct ClubInfo: Codable{
    let clubIdx: Int
    let clubName: String
    let isAdmin, clubType: Int
    let univOrLocation, oneLine, categoryList, activeNum, meetingTime, clubFee, clubWebsite, introduce, clubPhotoUrlList: String
    let score0sum, score1sum, score2sum, score3sum, score4sum, scoreNum, userIdx: Int
    let regDate: String
    let aveScore0, aveScore1, aveScore2, aveScore3, aveScore4: Float
    let isMine: Int
    let clubPostList: [ReviewInfo]
}

struct ClubAbout {
    static let locations = ["서울", "경기", "부산", "대전", "강원도", "충북", "충남", "전라도"]
    static let categorys = ["스터디/학회", "어학", "봉사", "여행", "스포츠", "문화생활", "음악/예술", "IT/공학", "창업", "친목", "기타"]
}
