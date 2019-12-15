// To parse the JSON, add this file to your project and do:
//
//   let userNetworkModel = try? newJSONDecoder().decode(UserNetworkModel.self, from: jsonData)

import Foundation

struct UserInfomationResponse: Codable {
    let status: Int?
    let message: String?
    let data: UserInfomation?
    
    init(status: Int?, message: String?, data: UserInfomation?) {
        self.status = status
        self.message = message
        self.data = data
    }
}

struct UserInfomation: Codable {
    let userIdx: Int?
    let userEmail: String?
    let userName, userBirth, userNickname: String?
    let userUniv, userMajor: String?
    let userGrade: Int?
    let userStudentNum, userGender, userSignOutDate, userSignInDate: String?
    let userPushAllow, userIsSeeker, userCnt, userInfoAllow: Int?
    let userProfileUrl: String?
    let userAlreadyOut: Int?
    let lastLoginTime: String?
    let signupType: Int?
    let userId: String?
    let uuid: String?
    let wannaJob: String?
    let wannaJobNumList: [Int]?
    let userInterest: String?
    
    init(userIdx: Int?,
         userEmail: String?,
         userName: String?,
         userBirth: String?,
         userNickname: String?,
         userUniv: String?,
         userMajor: String?,
         userGrade: Int?,
         userStudentNum: String?,
         userGender: String?,
         userSignOutDate: String?,
         userSignInDate: String?,
         userPushAllow: Int?,
         userIsSeeker: Int?,
         userCnt: Int?,
         userInfoAllow: Int?,
         userProfileUrl: String?,
         userAlreadyOut: Int?,
         lastLoginTime: String?,
         signupType: Int?,
         userId: String?,
         uuid: String?,
         wannaJob: String?,
         wannaJobNumList: [Int]?,
         userInterest: String?) {
        self.userIdx = userIdx
        self.userEmail = userEmail
        self.userName = userName
        self.userBirth = userBirth
        self.userNickname = userNickname
        self.userUniv = userUniv
        self.userMajor = userMajor
        self.userGrade = userGrade
        self.userStudentNum = userStudentNum
        self.userGender = userGender
        self.userSignOutDate = userSignOutDate
        self.userSignInDate = userSignInDate
        self.userPushAllow = userPushAllow
        self.userIsSeeker = userIsSeeker
        self.userCnt = userCnt
        self.userInfoAllow = userInfoAllow
        self.userProfileUrl = userProfileUrl
        self.userAlreadyOut = userAlreadyOut
        self.lastLoginTime = lastLoginTime
        self.signupType = signupType
        self.userId = userId
        self.uuid = uuid
        self.wannaJob = wannaJob
        self.wannaJobNumList = wannaJobNumList
        self.userInterest = userInterest
    }
    
    init(userInfomation: UserInfomation?) {
        self.userIdx = userInfomation?.userIdx
        self.userEmail = userInfomation?.userEmail
        self.userName = userInfomation?.userName
        self.userBirth = userInfomation?.userBirth
        self.userNickname = userInfomation?.userNickname
        self.userUniv = userInfomation?.userUniv
        self.userMajor = userInfomation?.userMajor
        self.userGrade = userInfomation?.userGrade
        self.userGender = userInfomation?.userGender
        self.userSignOutDate = userInfomation?.userSignOutDate
        self.userSignInDate = userInfomation?.userSignInDate
        self.userPushAllow = userInfomation?.userPushAllow
        self.userIsSeeker = userInfomation?.userIsSeeker
        self.userCnt = userInfomation?.userCnt
        self.userInfoAllow = userInfomation?.userInfoAllow
        self.userProfileUrl = userInfomation?.userProfileUrl
        self.userAlreadyOut = userInfomation?.userAlreadyOut
        self.lastLoginTime = userInfomation?.lastLoginTime
        self.signupType = userInfomation?.signupType
        self.userId = userInfomation?.userId
        self.uuid = userInfomation?.uuid
        self.wannaJob = userInfomation?.wannaJob
        self.wannaJobNumList = userInfomation?.wannaJobNumList
        self.userInterest = userInfomation?.userInterest

        guard let stringStudentNumber = userInfomation?.userStudentNum,
            let userStudentNumber = Int(stringStudentNumber) else {
                self.userStudentNum = userInfomation?.userStudentNum
                return
        }
        
        if stringStudentNumber.count > 2 {
            let year = Calendar.current.component(.year, from: Date())
            let minYear = year - 10
            if userStudentNumber <= minYear {
                self.userStudentNum = String(minYear % 100)
            } else {
                self.userStudentNum = String(userStudentNumber % 100)
            }
        } else {
            self.userStudentNum = userInfomation?.userStudentNum
        }
    }
}
