//
//  HJMonth.swift
//  SsgSag
//
//  Created by 이혜주 on 07/10/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

class HJMonth {
    var month: Int = 0
    var startDate: Date = Date()
    var days: [HJDay] = []
    var todoData: [[MonthTodoData]] = []
    var numberOfDay: Int = 0
    var startDay: Int = 0
    
    let calendar = Calendar.current
    
    init(_ date: Date) {
        startDate = startOfMonth(date)
        month = calendar.component(.month,
                                   from: startDate)
        numberOfDay = getDaysInMonth()
        startDay = getStartDay(startDate)
        
        setupDays()
    }
    
    private func setupDays() {
        for day in 0..<numberOfDay {
            guard let date = calendar.date(byAdding: .day, value: day, to: startDate) else {
                return
            }
            days.append(HJDay(date))
        }
    }
    
    private func getDaysInMonth() -> Int {
        let dateComponents = DateComponents(year: calendar.component(.year,
                                                                     from: startDate),
                                            month: calendar.component(.month,
                                                                      from: startDate))
        
        guard let date = calendar.date(from: dateComponents),
            let range = calendar.range(of: .day,
                                       in: .month,
                                       for: date) else {
            return 0
        }
        
        let numDays = range.count
        
        return numDays
    }

    // month의 시작 날짜 반환
    func startOfMonth(_ date: Date) -> Date {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let components = Calendar.current.dateComponents([.year, .month],
                                                         from: startOfDay)
        guard let startOfMonth = Calendar.current.date(from: components) else {
            return Date()
        }
        
        return startOfMonth
    }

    // 1 -> 일, 7 -> 토
    // 시작 요일 반환
    func getStartDay(_ date: Date) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        let weekDay = calendar.component(.weekday,
                                         from: date)
        return weekDay
    }
}

//enum DayOfTheWeek: Int {
//    case Mon = 0
//    case Tue = 1
//    case Wed = 2
//    case Thu = 3
//    case Fri = 4
//    case Sat = 5
//    case Sun = 6
//}
