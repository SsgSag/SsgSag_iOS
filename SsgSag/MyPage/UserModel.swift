//
//  User.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 12..
//  Copyright © 2019년 wndzlf. All rights reserved.
//

// To parse the JSON, add this file to your project and do:
//
//   let career = try? newJSONDecoder().decode(Career.self, from: jsonData)

import Foundation

struct UserModel: Codable {
    let status: Int
    let message: String
    let data: DataClass
}

struct DataClass: Codable {
    let userIdx: Int
    let userEmail, userPw, userID, userName: String
    let userUniv, userMajor, userStudentNum, userGender: String
    let userBirth, userSignOutDate, userSignInDate: String
    let userPushAllow, userIsSeeker, userCnt, userInfoAllow: Int
    let userProfileURL: String
    let userAlreadyOut, userGrade: Int
    
    enum CodingKeys: String, CodingKey {
        case userIdx, userEmail, userPw
        case userID = "userId"
        case userName, userUniv, userMajor, userStudentNum, userGender, userBirth, userSignOutDate, userSignInDate, userPushAllow, userIsSeeker, userCnt, userInfoAllow
        case userProfileURL = "userProfileUrl"
        case userAlreadyOut, userGrade
    }
}
