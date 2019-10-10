//
//  CalendarDataSourceContainer.swift
//  SsgSag
//
//  Created by 이혜주 on 09/10/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

class CalendarDataSourceContainer {
    private let dataSourcePool = CalendarDataSourcePool()
    
    public static let shared: CalendarDataSourceContainer = CalendarDataSourceContainer()
    
    private init() {
        let calendarDataSource: CalendarCollectionViewDataSource
            = CalendarCollectionViewDataSource()
        
        let monthDataSource: MonthCollectionViewDataSource
            = MonthCollectionViewDataSource()
        
        let dayDataSource: DayCollectionViewDataSource
            = DayCollectionViewDataSource()
        
        do {
            try dataSourcePool.register(key: .calendarDataSource,
                                        dependency: calendarDataSource)
            
            try dataSourcePool.register(key: .monthDataSource,
                                        dependency: monthDataSource)
            
            try dataSourcePool.register(key: .dayDataSource, dependency: dayDataSource)
        } catch {
            fatalError("register Fail")
        }
        
    }
    
    public func getDependency<T>(key: CalendarDataSourceKey) -> T {
        do {
            return try dataSourcePool.pullOutDependency(key: key)
        } catch CalendarDataSourceError.keyAlreadyExistsError {
            fatalError("keyAlreadyExistError")
        } catch CalendarDataSourceError.unregisteredKeyError {
            fatalError("unregisteredKeyError")
        } catch CalendarDataSourceError.downcastingFailureError {
            fatalError("downcastingFailureError")
        } catch {
            fatalError("getDependency Fail")
        }
    }
}

enum CalendarDataSourceKey {
    case calendarDataSource
    case monthDataSource
    case dayDataSource
}
