//
//  DayTodoList.swift
//  SsgSag
//
//  Created by 이혜주 on 09/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

// MARK: - DayTodoList
struct DayTodoList: Codable {
    let status: Int
    let message: String
    let data: [DayTodoData]
}

// MARK: - DayTodoData
struct DayTodoData: Codable {
    let posterIdx, categoryIdx, isCompleted, isEnded: Int
    let posterName, outline, posterEndDate: String
    let posterStartDate: String?
    let documentDate: String
    let isFavorite: Int
    let photoUrl: String?
    let dday: Int
}
