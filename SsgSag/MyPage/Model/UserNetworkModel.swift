// To parse the JSON, add this file to your project and do:
//
//   let userNetworkModel = try? newJSONDecoder().decode(UserNetworkModel.self, from: jsonData)

import Foundation

struct UserNetworkModel: Codable {
    let status: Int
    let message: String
    let data: UserInfoModel
}

struct UserInfoModel: Codable {
    let userIdx: Int
    let userEmail: String?
    let userName, userBirth, userNickname: String
    let userUniv, userMajor: String
    let userGrade: Int
    let userStudentNum, userGender, userSignOutDate, userSignInDate: String
    let userPushAllow, userIsSeeker, userCnt, userInfoAllow: Int
    let userProfileURL: String
    let userAlreadyOut: Int
    let lastLoginTime: String
    let signupType: Int
    let userID: String
    
    enum CodingKeys: String, CodingKey {
        case userIdx, userEmail, userName, userBirth, userNickname, userUniv, userMajor, userGrade, userStudentNum, userGender, userSignOutDate, userSignInDate, userPushAllow, userIsSeeker, userCnt, userInfoAllow
        case userProfileURL = "userProfileUrl"
        case userAlreadyOut, lastLoginTime, signupType
        case userID = "userId"
    }
}
