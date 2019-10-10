//
//  CalendarDataSourcePool.swift
//  SsgSag
//
//  Created by 이혜주 on 09/10/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

class CalendarDataSourcePool {
    private var dataSourcePool: [CalendarDataSourceKey: Any] = [:]
    
    func register<T>(key: CalendarDataSourceKey,
                     dependency: T) throws {
        
        guard dataSourcePool[key] == nil else {
            throw CalendarDataSourceError.keyAlreadyExistsError(key: key)
        }
        
        dataSourcePool.updateValue(dependency,
                                   forKey: key)
    }
    
    func pullOutDependency<T>(key: CalendarDataSourceKey) throws -> T {
        guard let rawDependency = dataSourcePool[key] else {
            throw CalendarDataSourceError.unregisteredKeyError(key: key)
        }
        
        guard let dependency = rawDependency as? T else {
            throw CalendarDataSourceError.downcastingFailureError(key: key)
        }
        
        return dependency
    }
}

enum CalendarDataSourceError: Error {
    case keyAlreadyExistsError(key: CalendarDataSourceKey)
    case unregisteredKeyError(key: CalendarDataSourceKey)
    case downcastingFailureError(key: CalendarDataSourceKey)
}
