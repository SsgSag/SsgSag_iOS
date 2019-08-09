//
//  ActicityServiceProtocol.swift
//  SsgSag
//
//  Created by 이혜주 on 27/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

protocol ActivityService: class {
    func requestDeleteActivity(
        contentIdx: Int,
        completionHandler: @escaping ((DataResponse<Activity>) -> Void)
    )
}
