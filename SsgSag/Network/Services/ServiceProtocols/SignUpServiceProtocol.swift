//
//  SignUpServiceProtocol.swift
//  SsgSag
//
//  Created by 이혜주 on 28/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

protocol SignupService: class {
    // 이메일 유효성 검사
    func requestValidateEmail(
        urlString: String,
        completionHandler: @escaping (DataResponse<HttpStatusCode>, Bool) -> Void
    )
    
    func requestValidateNickName(
        nickName: String,
        completionHandler: @escaping (DataResponse<HttpStatusCode>, Bool) -> Void
    )
    
    // 회원가입 요청
    func requestSingup(
        _ userInfo: [String: Any],
        completionHandler: @escaping (DataResponse<Signup>) -> Void
    )
}
