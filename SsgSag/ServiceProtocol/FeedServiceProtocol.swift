//
//  FeedServiceProtocol.swift
//  SsgSag
//
//  Created by 이혜주 on 02/08/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

protocol FeedService: class {
    func requestFeedData(
        completionHandler: @escaping (DataResponse<[FeedData]>) -> Void
    )
}
