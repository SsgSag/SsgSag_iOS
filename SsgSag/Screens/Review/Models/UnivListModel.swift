//
//  UnivListModel.swift
//  SsgSag
//
//  Created by 남수김 on 2020/03/13.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation

struct UnivListModel: Codable {
    let 학교명: String
    let 학과명: [String]
    
    enum CodingKeys: String, CodingKey {
        case 학교명
        case 학과명 = "학부·과(전공)명"
    }
}
