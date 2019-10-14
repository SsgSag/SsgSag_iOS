//
//  HJDay.swift
//  SsgSag
//
//  Created by 이혜주 on 07/10/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

class HJDay {
    var day: Int = 0
    var date: Date?
//    var todoData: [MonthTodoData] = []
    
    init(_ date: Date) {
        self.date = date
        day = Calendar.current.component(.day,
                                         from: date)
    }
    
    func getColorOfDay() -> UIColor {
        return #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
}
