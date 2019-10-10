//
//  HJMonth.swift
//  SsgSag
//
//  Created by 이혜주 on 07/10/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

class HJMonth {
    var startDate: Date?
    var days: [HJDay] = []
    var todoData: [[MonthTodoData]] = []
    var startDayOfTheWeek: DayOfTheWeek?
    
    init(_ month: Int) {
        let calendar = Calendar.current
        let components = DateComponents(year: 2019, month: month, day: 1)
        startDate = calendar.date(from: components)
    }
    
    func getDaysInMonth() -> Int {
        guard let startDate = startDate else {
            return 0
        }
 
        let calendar = Calendar.current
        
        let dateComponents = DateComponents(year: calendar.component(.year, from: startDate),
                                            month: calendar.component(.month, from: startDate))
        
        guard let date = calendar.date(from: dateComponents),
            let range = calendar.range(of: .day, in: .month, for: date) else { return 0 }
        
        let numDays = range.count
        
        return numDays
    }

    func startOfMonth(_ date: Date) -> Date {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let components = Calendar.current.dateComponents([.year, .month], from: startOfDay)
        guard let startOfMonth = Calendar.current.date(from: components) else {
            return Date()
        }
        return startOfMonth
    }

    // 1 -> 일, 7 -> 토
    func getStartDay(_ date: Date) -> Int? {
        let calendar = Calendar(identifier: .gregorian)
        let weekDay = calendar.component(.weekday, from: date)
        return weekDay
    }
    
    func getNumberOfWeek() {
        
    }
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
