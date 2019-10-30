//
//  LoginStruct.swift
//  SsgSag
//
//  Created by 이혜주 on 30/10/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

struct LoginStruct: Codable {
    let status: Int?
    let message: String?
    let data: login?
}

struct login: Codable {
    let token: String?
}
