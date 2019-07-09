//
//  MonthTodoList.swift
//  SsgSag
//
//  Created by 이혜주 on 09/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

// MARK: - MonthTodoList
struct MonthTodoList: Codable {
    let status: Int
    let message: String
    let data: [MonthTodoData]
}

// MARK: - MonthTodoData
struct MonthTodoData: Codable {
    let posterIdx, categoryIdx, isCompleted, isEnded: Int
    let posterName, outline, posterStartDate, posterEndDate: String
    let documentDate: String
    let isFavorite, dday: Int
}
