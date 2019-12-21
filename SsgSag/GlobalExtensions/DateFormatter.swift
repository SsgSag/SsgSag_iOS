//
//  DateFormatter.swift
//  SsgSag
//
//  Created by admin on 17/04/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    private static let genericFormatter = DateFormatter.databaseISO8601FormatterFactory()
    
    private class func databaseISO8601FormatterFactory() -> DateFormatter {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter
    }
    
    public func getGenericFormatter() -> DateFormatter {
        return .genericFormatter
    }
    
}


