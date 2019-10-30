//
//  MyPageServiceProtocol.swift
//  SsgSag
//
//  Created by 이혜주 on 27/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

protocol MyPageService: class {
    
    // 회원관심분야 조회
    func requestSelectedState(
        completionHandler: @escaping ((DataResponse<Interests>) -> Void)
    )
    
    // 회원관심분야 재설정
    func requestStoreSelectedField(
        _ selectedIndex: [Int],
        completionHandler: @escaping ((DataResponse<HttpStatusCode>) -> Void)
    )
    
    // 회원 탈퇴
    func requestMembershipCancel(
        completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void
    )
    
    // 비밀번호 재설정
    func requestChangePassword(
        oldPassword: String,
        newPassword: String,
        completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void
    )
    
    // 마이페이지 정보 업데이트
    func requestUpdateUserInfo(
        bodyData: [String: Any],
        completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void
    )
    
    // 프로필 이미지 업데이트
    func requestUpdateProfileImage(
        boundary: String,
        bodyData: Data,
        completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void
    )
    
}
