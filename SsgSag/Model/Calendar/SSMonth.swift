//
//  SSMonth.swift
//  SsgSag
//
//  Created by 이혜주 on 04/10/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

class SSMonth {
    var month: Int?
    var weeks: [SSDay] = []
    var startDayOfTheWeek: DayOfTheWeek?
}

enum DayOfTheWeek: Int {
    case Mon = 0
    case Tue = 1
    case Wed = 2
    case Thu = 3
    case Fri = 4
    case Sat = 5
    case Sun = 6
}
