//
//  UnivAndMajor.swift
//  SsgSag
//
//  Created by 이혜주 on 10/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

// MARK: - MonthTodoListElement
struct UnivAndMajor: Codable {
    let 조사년도: Int
    let 대학구분: String
    let 학교구분: String
    let 설립구분: String
    let 지역: String
    let 학교명: String
    let 본분교명: String
    let 단과대학, 학부과전공명: String
    let 주야구분: String
    let 학과특성: String
    let 학과상태: String
    let 대계열: String
    let 중계열: String
    let 소계열: String
    let 수업연한: String
    let 학위과정: String
    
    enum CodingKeys: String, CodingKey {
        case 조사년도, 대학구분, 학교구분, 설립구분, 지역, 학교명, 본분교명, 단과대학
        case 학부과전공명 = "학부·과(전공)명"
        case 주야구분, 학과특성, 학과상태, 대계열, 중계열, 소계열, 수업연한, 학위과정
    }
}
