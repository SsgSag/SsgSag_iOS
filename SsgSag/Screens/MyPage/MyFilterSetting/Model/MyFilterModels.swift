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

struct MyFilterSetting: Decodable {
    let jobKind: [String]
    let interestedField: [String]
    let grade: Int
    
    init() {
        jobKind = []
        interestedField = []
        grade = 3
    }
    
    init(jobKind: [String],
         interestedField: [String],
         grade: Int) {
        self.jobKind = jobKind
        self.interestedField = interestedField
        self.grade = grade
    }
    
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
    
    func map(interests: [Int]?) -> MyFilterSetting {
        guard let interests = interests else { return .init() }
        let jobKind = interests
            .filter { categorizedDictionary["jobKind"]!.contains($0) }
            .compactMap { (value) -> String in
                if value == 299 {
                    return "기타"
                } else {
                    return mapDictionary.getKey(forValue: value) ?? ""
                }
            }
        
        let interestedField = interests
            .filter { categorizedDictionary["interestedField"]!.contains($0) }
            .compactMap { (value) -> String in
                if value == 299 {
                    return "기타"
                } else {
                    return mapDictionary.getKey(forValue: value) ?? ""
                }
            }
        
        
        let grade = interests.filter { categorizedDictionary["grade"]!.contains($0) }
            .compactMap { Int(mapDictionary.getKey(forValue: $0) ?? "1") }.first ?? 1
        
        let myFilterSetting = MyFilterSetting(jobKind: jobKind,
                                              interestedField: interestedField,
                                              grade: grade)
        return myFilterSetting
    }
    
    let categorizedDictionary = ["jobKind": [301,302,303,304,305,299],
                                 "interestedField": [201,202,205,206,207,208,215,251,252,299],
                                 "grade": [501,502,503,504,505]
    ]
    
    let mapDictionary = [
                         "개발자": 301,
                         "디자이너": 302,
                         "마케터": 303,
                         "기획자": 304,
                         "기획/아이디어": 201,
                         "광고/마케팅": 202,
                         "디자인": 205,
                         "영상/콘텐츠": 206,
                         "IT/공학": 207,
                         "창업/스타트업": 208,
                         "금융/경제": 215,
                         "서포터즈": 251,
                         "봉사활동": 252,
                         "기타": 305,
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
extension Dictionary where Value: Equatable {
    func getKey(forValue val: Value) -> Key? {
        return first(where: { (dict) in dict.value == val })?.key
    }
}
