//
//  LoginServiceProtocol.swift
//  SsgSag
//
//  Created by 이혜주 on 27/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

protocol LoginService: class {
    // SNS로 로그인을 시도했을 때
    func requestSnsLogin(
        using accessToken: String,
        type login: Int,
        completionHandler: @escaping (DataResponse<TokenResponse>) -> Void
    )
    
    // 자체로그인으로 로그인을 시도했을 때
    func requestSelfLogin(
        send data: [String: Any],
        completionHandler: @escaping (DataResponse<LoginStruct>) -> Void
    )
    
    // 임시비밀번호 요청
    func requestTempPassword(
        email: String,
        completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void
    )
    
    // KeychainWrapper에 저장된 token 값으로 자동로그인 요청
    func requestAutoLogin(
        completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void
    )
}
