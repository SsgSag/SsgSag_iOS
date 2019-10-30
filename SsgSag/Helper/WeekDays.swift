//
//  WeekDays.swift
//  SsgSag
//
//  Created by 이혜주 on 30/10/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

enum WeekDays: Int {
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thurday = 5
    case friday = 6
    case saturday = 7
    case sunday = 1
    
    var koreanWeekdays: String {
        switch self {
        case .monday:
            return "월"
        case .tuesday:
            return "화"
        case .wednesday:
            return "수"
        case .thurday:
            return "목"
        case .friday:
            return "금"
        case .saturday:
            return "토"
        case .sunday:
            return "일"
        }
    }
}
