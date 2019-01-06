//
//  sampleDataVO.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 5..
//  Copyright © 2019년 wndzlf. All rights reserved.
//

import Foundation

struct eateryVO: Codable {
    let data: resType
    struct resType: Codable {
        let activity: [list]
        let prize: [list]
        let certification: [list]
        
        
    }
}

struct list: Codable {
    let title: String
    let date: String
    let content: String
}
