//
//  Feed.swift
//  SsgSag
//
//  Created by 이혜주 on 02/08/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

// MARK: - Feed
struct Feed: Codable {
    let status: Int?
    let message: String?
    let data: [FeedData]?
}

// MARK: - FeedData
struct FeedData: Codable {
    let feedIdx: Int?
    let feedName, feedHost: String?
    let feedUrl: String?
    let feedRegDate: String?
    let feedPreviewImgUrl: String?
    let showNum, isSave: Int?
}
