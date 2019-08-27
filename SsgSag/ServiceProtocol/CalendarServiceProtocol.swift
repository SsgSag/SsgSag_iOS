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
    
    func requestFavorite(
        _ favorite: favoriteState,
        _ posterIdx: Int,
        completionHandler: @escaping (DataResponse<PosterFavorite>) -> Void
    )
    
    func requestDelete(
        _ posterIdx: Int,
        completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void
    )
    
    func reqeustComplete(
        _ posterIdx: Int,
        completionHandler: @escaping (DataResponse<PosterFavorite>) -> Void
    )
    
    func requestEachPoster(
        _ posterIdx: Int,
        completionHandler: @escaping (DataResponse<networkPostersData>) -> Void
    )
}
