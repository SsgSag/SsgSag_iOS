//
//  CareerServiceProtocol.swift
//  SsgSag
//
//  Created by 이혜주 on 28/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

protocol CareerService {
    func requestCareerWith(
        careerType: Int,
        completionHandler: @escaping (DataResponse<Career>) -> Void
    )
    
    func requestCareerWith(
        body: [String: Any],
        completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void
    )
}
