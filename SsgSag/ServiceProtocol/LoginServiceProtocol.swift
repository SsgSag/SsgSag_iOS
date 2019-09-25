//
//  LoginServiceProtocol.swift
//  SsgSag
//
//  Created by 이혜주 on 27/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

protocol LoginService: class {
    func requestSnsLogin(
        using accessToken: String,
        type login: Int,
        completionHandler: @escaping (DataResponse<TokenResponse>) -> Void
    )
    
    func requestSelfLogin(
        send data: [String:Any],
        completionHandler: @escaping (DataResponse<LoginStruct>) -> Void
    )
    
    func requestTempPassword(
        email: String,
        completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void
    )
    
    func requestAutoLogin(
        completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void
    )
}
