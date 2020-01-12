//
//  DateCaculate.swift
//  SsgSag
//
//  Created by admin on 30/04/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

struct DateCaculate {
    
    static func isSameDate(_ firstDate: Date , _ secondDate: Date) -> Bool {
        let firstDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: firstDate)
        let secondDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: secondDate)
        
        if firstDateComponents.year! == secondDateComponents.year! &&
            firstDateComponents.month! == secondDateComponents.month! &&
            firstDateComponents.day! == secondDateComponents.day! {
            return true
        }
        
        return false
    }
    
    static func stringToDateWithBasicFormatterWithKorea(using stringDate: String) -> Date {
        let dateFormatter = DateFormatter.basicDateFormatterWithKorea
        
        guard let date = dateFormatter.date(from: stringDate) else {return .init()}
        
        return date
    }
    
    static func stringToDateWithBasicFormatter(using stringDate: String) -> Date {
        let dateFormatter = DateFormatter.basicDateFormatter
        
        guard let date = dateFormatter.date(from: stringDate) else {return .init()}
        
        return date
    }
    
    static func stringToDateWithGenericFormatter(using stringDate: String) -> Date {
        let dateFormatter = DateFormatter.genericDateFormatter
        
        guard let date = dateFormatter.date(from: stringDate) else {return .init()}
        
        return date
    }
    
    static func getDateOfStringDay(_ year: Int, _ month: Int, day: Int) -> Date? {
        let dateFormatter = DateFormatter.genericDateFormatter
        
        let cellDateString = "\(year)-\(month)-\(day) 00:00:00"
        
        return dateFormatter.date(from: cellDateString)
    }
    
    static func dayInterval(using dateString: String) -> Int {
        
        let dateFormatter = DateFormatter.genericDateFormatter
        
        guard let posterEndDate = dateFormatter.date(from: dateString) else { return 0 }
        
        let dayInterval = Calendar.current.dateComponents([.day],
                                                          from: Date(),
                                                          to: posterEndDate)
        
        guard let interval = dayInterval.day else { return 0 }
        
        return interval
    }
    
    static func getDifferenceBetweenStartAndEnd(startDate: String?, endDate: String?) -> String {
        
        let dateFormatter = DateFormatter.genericDateFormatter
        
        guard let endDateString = endDate else { return "" }
        
        guard let posterEndDate = dateFormatter.date(from: endDateString) else { return "" }
        
        guard let startDateString = startDate,
            let posterStartDate = dateFormatter.date(from: startDateString) else {
                let endDate = Calendar.current.dateComponents([.month, .day, .weekday], from: posterEndDate)
            
                guard let endMonth = endDate.month else { return "" }
            
                guard let endDay = endDate.day else { return "" }
            
                guard let endWeekDay = endDate.weekday,
                    let endWeekDayString = WeekDays(rawValue: endWeekDay)?.koreanWeekdays else { return "" }

                return "~ \(endMonth).\(endDay)"
        }
        
        let startDate = Calendar.current.dateComponents([.month, .day, .weekday], from: posterStartDate)
        
        let endDate = Calendar.current.dateComponents([.month, .day, .weekday], from: posterEndDate)
        
        guard let startMonth = startDate.month else {return ""}
        
        guard let startDay = startDate.day else {return ""}
        
        guard let startWeekDay = endDate.weekday,
            let startWeekDayString = WeekDays(rawValue: startWeekDay)?.koreanWeekdays else { return "" }
        
        guard let endMonth = endDate.month else {return ""}
        
        guard let endDay = endDate.day else {return ""}

        guard let endWeekDay = endDate.weekday,
            let endWeekDayString = WeekDays(rawValue: endWeekDay)?.koreanWeekdays else { return "" }
        
        return "\(startMonth).\(startDay) ~ \(endMonth).\(endDay)"
    }
 
    
}
