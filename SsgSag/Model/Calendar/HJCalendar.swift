//
//  HJCalendar.swift
//  SsgSag
//
//  Created by 이혜주 on 07/10/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

class HJCalendar {
    
    var todoData: [[[MonthTodoData]]] = []
    var months: [HJMonth] = []
    var currentDate: Date?
    var today: Date = Date()
    let calendar = Calendar.current
    
    var todoService: CalendarService
        = DependencyContainer.shared.getDependency(key: .calendarService)

    init() {
        currentDate = today
        
        requestData()
        setupCalendar()
    }
    
    func setupCalendar() {
        guard let currentDate = currentDate else {
            return
        }
        
        // months 생성
        for index in -2...2 {
            guard let date = calendar.date(byAdding: .month,
                                           value: index,
                                           to: currentDate) else {
                return
            }
            
            let month = HJMonth(date)
            months.append(month)
        }
    }
    
    func getMonths() -> [HJMonth] {
        return months
    }
    
    func addNextMonths() {
        let lastMonth = months[months.endIndex - 1].startDate
        
        // months 생성
        for index in 1..<4 {
            guard let date = calendar.date(byAdding: .month,
                                           value: index,
                                           to: lastMonth) else {
                return
            }
            
            let month = HJMonth(date)
            months.append(month)
        }
    }
    
    func addPreviousMonths() {
        let firstMonth = months[0].startDate
        
        // months 생성
        for index in 1..<4 {
            guard let date = calendar.date(byAdding: .month,
                                           value: -index,
                                           to: firstMonth) else {
                return
            }
            
            let month = HJMonth(date)
            months.insert(month, at: 0)
        }
    }
    
    func requestData() {
        //TODO: 데이터 네트워킹
    }
}
