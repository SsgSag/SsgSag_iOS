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
    let status: Int?
    let message: String?
    let data: [MonthTodoData]?
}

// MARK: - MonthTodoData
struct MonthTodoData: Codable, Equatable, Hashable {
    let posterIdx, categoryIdx, isCompleted, isEnded: Int?
    let subCategoryIdx: Int?
    let posterName, outline, posterEndDate: String?
    let posterStartDate: String?
    let documentDate: String?
    let isFavorite: Int?
    let photoUrl: String?
    let dday: Int?
    
    static func == (lhs: MonthTodoData, rhs: MonthTodoData) -> Bool {
        if lhs.posterName == rhs.posterName {
            return true
        }
        return false
    }
}
