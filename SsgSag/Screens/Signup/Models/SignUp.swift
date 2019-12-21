//
//  SignUp.swift
//  SsgSag
//
//  Created by 이혜주 on 22/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

// MARK: - Signup
struct Signup: Codable {
    let status: Int?
    let message: String?
    let data: SignUpData?
}

// MARK: - DataClass
struct SignUpData: Codable {
    let token: String
}
