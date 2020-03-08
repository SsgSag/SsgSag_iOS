//
//  Blog.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/21.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation

struct BlogInfo: Codable {
    let clubBlogIdx: Int
    let blogUrl, blogRegDate, blogNickname,
    blogTitle, blogDescription, regDate : String
    let clubIdx: Int
    let blogImageUrl: String?
}
