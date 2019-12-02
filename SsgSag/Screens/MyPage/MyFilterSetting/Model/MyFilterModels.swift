//
//  MyFilterModels.swift
//  SsgSag
//
//  Created by bumslap on 01/12/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

struct MyFilterHeader {
    let title: String
    let description: String
}

struct MyFilterSetting {
    let jobKind: [String]
    let interestedField: [String]
    let grade: Int
    
    func map() -> [Int] {
        let mappedJobKind = jobKind.map {
            mapDictionary[$0]
        }.compactMap { $0 }
        
        let mappedInterestedField = interestedField.map {
            mapDictionary[$0]
        }.compactMap { $0 }
        
        let mappedGrade = mapDictionary["\(grade)"] ?? 1
        
        var mergedArray = Array([mappedJobKind, mappedInterestedField].joined())
        mergedArray.append(mappedGrade)
        
        return mergedArray.sorted()
    }
    
    let mapDictionary = [
                         "개발자": 301,
                         "디자이너": 302,
                         "마케터": 303,
                         "기획자": 304,
                         "모르겠어요": 305,
                         "기획/아이디어": 201,
                         "광고/마케팅": 202,
                         "디자인": 205,
                         "영상/콘텐츠": 206,
                         "IT/공학": 207,
                         "창업/스타트업": 208,
                         "금융/경제": 215,
                         "서포터즈": 251,
                         "봉사활동": 252,
                         "기타": 299,
                         "1": 501,
                         "2": 502,
                         "3": 503,
                         "4": 504,
                         "5": 505,
                         "대기업": 10000,
                         "중견기업": 20000,
                         "강소기업": 30000,
                         "공사/공기업": 50000,
                         "외국계기업": 60000,
                         "스타트업": 40000,
                         "정부/지방자치단체": 70000,
                         "비영리단체/재단": 85000,
                         "기타단체": 95000,
                        ]
}
