//
//  CalendarServiceProtocol.swift
//  SsgSag
//
//  Created by 이혜주 on 27/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

protocol CalendarService: class {
    func requestMonthTodoList(
        year: String,
        month: String,
        completionHandler: @escaping (DataResponse<[MonthTodoData]>) -> Void
    )
    
    func requestDayTodoList(
        year: String,
        month: String,
        day: String,
        completionHandler: @escaping (DataResponse<[DayTodoData]>) -> Void
    )
    
    func requestTodoFavorite(
        _ favorite: favoriteState,
        _ posterIdx: Int,
        completionHandler: @escaping (DataResponse<PosterFavorite>) -> Void
    )
    
    func requestTodoDelete(
        _ posterIdx: Int,
        completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void
    )
    
    func reqeustApplyComplete(
        _ posterIdx: Int,
        completionHandler: @escaping (DataResponse<PosterFavorite>) -> Void
    )
}
