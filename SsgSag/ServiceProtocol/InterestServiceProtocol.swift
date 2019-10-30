//
//  InterestServiceProtocol.swift
//  SsgSag
//
//  Created by 이혜주 on 28/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

protocol InterestService: class {
    // 구독상태 조회
    func requestInterestSubscribeStatus(
        completionHandler: @escaping (DataResponse<Subscribe>) -> Void
    )
    
    // 구독 취소
    func requestInterestSubscribeDelete(
        _ interedIdx: Int,
        completionHandler: @escaping (DataResponse<BasicResponse>) -> Void
    )
    
    // 구독 등록
    func requestInterestSubscribeAdd(
        _ interedIdx: Int,
        completionHandler: @escaping (DataResponse<BasicResponse>) -> Void
    )
}
