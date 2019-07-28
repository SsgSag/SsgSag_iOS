//
//  NoticeServiceProtocol.swift
//  SsgSag
//
//  Created by 이혜주 on 28/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

protocol NoticeService: class {
    func requestNotice(
        completionHandler: @escaping (DataResponse<[NoticeData]>) -> Void
    )
}
