//
//  ActicityServiceProtocol.swift
//  SsgSag
//
//  Created by 이혜주 on 27/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

protocol ActivityService: class {
    // 이력 데이터 요청
    func requestCareerWith(
        careerType: Int,
        completionHandler: @escaping (DataResponse<Career>) -> Void
    )
    
    // 이력 추가
    func requestStoreActivity(
        _ jsonData: [String: Any],
        completionHandler: @escaping ((DataResponse<Activity>) -> Void)
    )
    
    // 이력 수정
    func requestEditActivity(
        _ jsonData: [String: Any],
        completionHandler: @escaping ((DataResponse<Activity>) -> Void)
    )
    
    // 이력 삭제
    func requestDeleteActivity(
        contentIdx: Int,
        completionHandler: @escaping ((DataResponse<Activity>) -> Void)
    )
}
