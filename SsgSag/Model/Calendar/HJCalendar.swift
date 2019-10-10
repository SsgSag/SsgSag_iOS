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
    var currentMonth: Int?
    var today: Date = Date()
    let calendar = Calendar.current
    
    var todoService: CalendarService
        = DependencyContainer.shared.getDependency(key: .calendarService)

    init() {
        currentMonth = calendar.component(.month,
                                          from: today)
        
        requestData()
        setupCalendar()
    }
    
    func setupCalendar() {
        guard let currentMonth = currentMonth else {
            return
        }
        
        // months 생성
        for index in -2...2 {
            let month = HJMonth(currentMonth + index)
            months.append(month)
        }
    }
    
    func getMonths() -> [HJMonth] {
        return months
    }
    
    // 3달치 month를 추가할 때 사용할 메소드
    func addMonth() {
        //TODO: months에 HJMonth 3달치 만들어서 추가하고, 3달치 데이터 네트워킹 요청
    }
    
    func requestData() {
        //TODO: 데이터 네트워킹
    }
}
