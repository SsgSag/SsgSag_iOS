//
//  Notice.swift
//  SsgSag
//
//  Created by 이혜주 on 22/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

// MARK: - UserInformation
struct Notice: Codable {
    let status: Int?
    let message: String?
    let data: [NoticeData]?
}

// MARK: - Datum
struct NoticeData: Codable {
    let noticeIdx: Int?
    let noticeName, noticeContent, noticeRegDate: String?
}
