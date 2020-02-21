//
//  Blog.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/21.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation

struct Blog: Codable {
    let display: Int
    let items: [BlogInfo]?
    let lastBuildDate: String
    let start: Int
    let total: Int
}

struct BlogInfo: Codable {
    let bloggerlink: String?
    let bloggername: String?
    let description: String?
    let link: String?
    let postdate: Int
    let title: String?
}
