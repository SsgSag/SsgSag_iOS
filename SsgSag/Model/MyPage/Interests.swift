//
//  Interests.swift
//  SsgSag
//
//  Created by CHOMINJI on 05/03/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//\

// To parse the JSON, add this file to your project and do:
//
//   let interests = try? newJSONDecoder().decode(Interests.self, from: jsonData)

import Foundation

struct Interests: Codable {
    let status: Int?
    let message: String?
    let data: Interest?
}

struct Interest: Codable {
    let interests: [Int]?
    let isSeeker: Int?
}
