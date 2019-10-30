//
//  CalendarServiceProtocol.swift
//  SsgSag
//
//  Created by 이혜주 on 27/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

protocol CalendarService: class {
    // calendar에 표시할 일정 데이터를 월 단위로 요청합니다.
    func requestMonthTodoList(
        year: String,
        month: String,
        _ categoryList: [Int],
        favorite: Int,
        completionHandler: @escaping (DataResponse<[MonthTodoData]>) -> Void
    )
    
    // calendar에 표시할 일정 데이터를 일 단위로 요청합니다.
    func requestDayTodoList(
        year: String,
        month: String,
        day: String,
        completionHandler: @escaping (DataResponse<[DayTodoData]>) -> Void
    )
    
    // 일정을 삭제합니다.
    func requestTodoDelete(
        _ posterIdxs: [Int],
        completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void
    )
    
    // 상세정보에서 click 정보를 서버에 전달합니다. (0: 웹사이트 클릭, 1: 바로지원 클릭, 2: 자세히보기 클릭)
    func requestTodoListClickRecord(
        _ posterIdx: Int,
        type: Int,
        completionHandler: @escaping (DataResponse<HttpStatusCode>) -> Void
    )
}
