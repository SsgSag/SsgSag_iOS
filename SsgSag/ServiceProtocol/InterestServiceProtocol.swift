//
//  InterestServiceProtocol.swift
//  SsgSag
//
//  Created by 이혜주 on 28/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

protocol InterestService: class {
    func requestInterestSubscribeStatus(
        completionHandler: @escaping (DataResponse<Subscribe>) -> Void
    )
    
    func requestInterestSubscribeDelete(
        _ interedIdx: Int,
        completionHandler: @escaping (DataResponse<BasicNetworkModel>) -> Void
    )
    
    func requestInterestSubscribeAdd(
        _ interedIdx: Int,
        completionHandler: @escaping (DataResponse<BasicNetworkModel>) -> Void
    )
}
