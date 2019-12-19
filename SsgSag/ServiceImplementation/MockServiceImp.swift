//
//  MockServiceImp.swift
//  SsgSag
//
//  Created by 이혜주 on 02/12/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class MockServiceImp: PosterService {
    
    let requestMaker: RequestMakerProtocol
    let network: Network
    
    init(requestMaker: RequestMakerProtocol,
         network: Network) {
        self.requestMaker = requestMaker
        self.network = network
    }
    
    func requestSwipePosters(completionHandler: @escaping (DataResponse<PosterData>) -> Void) {
        let poster = Posters.init(posterIdx: 1,
                                  categoryIdx: 0,
                                  subCategoryIdx: 0,
                                  photoUrl: "",
                                  posterName: "최신버전으로 업데이트해주세요",
                                  posterRegDate: "2019-01-22 00:35:49",
                                  posterStartDate: "2019-01-22 00:35:49",
                                  posterEndDate: "2019-02-11 23:59:59",
                                  posterWebSite: "www.s1-idea.co.kr",
                                  isSeek: 0,
                                  outline: "",
                                  target: "",
                                  period: "",
                                  benefit: "",
                                  documentDate: "23:59",
                                  contentIdx: 200,
                                  hostIdx: 20000,
                                  posterDetail: "detail",
                                  posterInterest: [0],
                                  dday: 0,
                                  adminAccept: 1,
                                  keyword: "해당 기능을 사용하려면 슥삭을 최신버전으로 업데이트해주세요:D",
                                  favoriteNum: 0,
                                  likeNum: 4)
        
        let posterData = PosterData.init([poster], 0)
        completionHandler(.success(posterData))
    }
    
    func requestPosterStore(of posterIdx: Int,
                            type likedCategory: likedOrDisLiked,
                            completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void) {
        
    }
    
    func requestPosterDetail(posterIdx: Int,
                             completionHandler: @escaping (DataResponse<DataClass>) -> Void) {
        
    }
    
    func requestPosterFavorite(index: Int,
                               method: HTTPMethod,
                               completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void) {
        
    }
    
    func requestAllPosterAfterSwipe(category: Int,
                                    sortType: Int,
                                    curPage: Int,
                                    completionHandler: @escaping (DataResponse<[PosterDataAfterSwpie]>) -> Void) {
        
    }
}

class MyPageMockServiceImp: MyPageService {
    
    let requestMaker: RequestMakerProtocol
    let network: Network
    
    init(requestMaker: RequestMakerProtocol,
         network: Network) {
        self.requestMaker = requestMaker
        self.network = network
    }
    
    func requestUserInfo(completionHandler: @escaping ((DataResponse<UserInfomationResponse>) -> Void)) {
        let userInfomation = UserInfomation(userIdx: 1,
                                            userEmail: "hhhuul098098@gmail.com",
                                            userName: "이혜주",
                                            userBirth: "950429",
                                            userNickname: "혜주혜주이혜주",
                                            userUniv: "인하대학교",
                                            userMajor: "컴퓨터공학과",
                                            userGrade: 5,
                                            userStudentNum: "1988",
                                            userGender: "male",
                                            userSignOutDate: "2019-02-03 18:45:18",
                                            userSignInDate: "2019-02-03 18:45:18",
                                            userPushAllow: 1,
                                            userIsSeeker: 0,
                                            userCnt: 15,
                                            userInfoAllow: 1,
                                            userProfileUrl: "https://s3.ap-northeast-2.amazonaws.com/project-hs/99ced6ba5175467ca71ea26a7ac4b3b6.png",
                                            userAlreadyOut: 0,
                                            lastLoginTime: "2019-02-03 21:50:08",
                                            signupType: 0,
                                            userId: "1012134787",
                                            uuid: "uuid",
                                            wannaJob: "예비 개발자",
                                            wannaJobNumList: [301, 302],
                                            userInterest: "#기획/아이디어 #광고/마케팅 #디자인 #서포터즈")
        
        let userInfomationResponse = UserInfomationResponse(status: 200,
                                                            message: "회원 정보 조회 성공",
                                                            data: userInfomation)
        
        completionHandler(.success(userInfomationResponse))
    }
    
    func requestSelectedState(completionHandler: @escaping ((DataResponse<Interests>) -> Void)) {
    }
    
    func requestStoreSelectedField(_ selectedIndex: [Int], completionHandler: @escaping ((DataResponse<HttpStatusCode>) -> Void)) {
    }
    
    func requestMembershipCancel(completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void) {
    }
    
    func requestChangePassword(oldPassword: String, newPassword: String, completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void) {
    }
    
    func requestUpdateUserInfo(bodyData: [String : Any], completionHandler: @escaping (DataResponse<UserInfomationResponse>) -> Void) {
    }
    
    func requestUpdateProfileImage(boundary: String, bodyData: Data, completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void) {
    }
    
}
