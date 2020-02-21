//
//  Blog.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/21.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation

struct BlogRss: Codable {
    let rss: String?
    let channel: Channel
}

struct Channel: Codable {
    let title: String?
    let link: String?
    let description: String?
    let lastBuildDate: Date
    let total: Int
    let start: Int
    let display: Int
    let items: BlogInfo
}

struct BlogInfo: Codable {
    let title: String?
    let link: String?
    let description: String?
    let bloggername: String?
    let bloggerlink: String?
    let postdate: Date
}
