//
//  DateCaculate.swift
//  SsgSag
//
//  Created by admin on 30/04/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

struct DateCaculate {
        
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
    
    static func getDateOfStringDay(_ year: Int, _ month: Int, day: Int) -> Date? {
        let dateFormatter = DateFormatter.genericDateFormatter
        
        let cellDateString = "\(year)-\(month)-\(day) 00:00:00"
        
        return dateFormatter.date(from: cellDateString)
    }
    
    static func dayInterval(using dateString: String) -> Int{
        
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
        
        guard let startDateString = startDate else {return ""}
        
        guard let endDateString = endDate else {return ""}
        
        guard let posterEndDate = dateFormatter.date(from: endDateString) else {return ""}
        
        guard let posterStartDate = dateFormatter.date(from: startDateString) else {return "X ~ \(posterEndDate)"}
        
        
        let startDate = Calendar.current.dateComponents([.month, .day], from: posterStartDate)
        
        let endDate = Calendar.current.dateComponents([.month, .day], from: posterEndDate)
        
        guard let startMonth = startDate.month else {return ""}
        
        guard let startDay = startDate.day else {return ""}
        
        guard let endMonth = endDate.month else {return ""}
        
        guard let endDay = endDate.day else {return ""}
        
        return "\(startMonth).\(startDay) ~ \(endMonth).\(endDay)"
    }
 
    
}