//
//  SignUpServiceProtocol.swift
//  SsgSag
//
//  Created by 이혜주 on 28/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

protocol SignupService: class {
    func requestValidateEmail(
        urlString: String,
        completionHandler: @escaping (DataResponse<HttpStatusCode>, Bool) -> Void
    )
    
    func requestSingup(
        _ userInfo: Data,
        completionHandler: @escaping (DataResponse<Signup>) -> Void
    )
}
