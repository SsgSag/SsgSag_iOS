//
//  SortType.swift
//  SsgSag
//
//  Created by 이혜주 on 19/12/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

enum SortType: Int {
    case latest = 0
    case deadline = 1
    case popular = 2
    
    func getTypeString() -> String {
        switch self {
        case .latest:
            return "최신순"
        case .deadline:
            return "마감순"
        case .popular:
            return "인기순"
        }
    }
}

enum InterestingFieldContest: Int, CaseIterable {
    case none = 0
    case idea = 201
    case ads = 202
    case design = 205
    case contents = 206
    case it = 207
    case startUp = 208
    case finance = 215
    case etc = 299
    
    func getTypeString() -> String {
        switch self {
        case .none:
            return "전체"
        case .idea:
            return "기획/아이디어"
        case .ads:
            return "광고/마케팅"
        case .design:
            return "디자인"
        case .contents:
            return "영상/콘텐츠"
        case .it:
            return "IT/공학"
        case .startUp:
            return "창업/스타트업"
        case .finance:
            return "금융/경제"
        case .etc:
            return "기타"
        }
    }
}
    
enum InterestingFieldActivity: Int, CaseIterable {
    case none = 0
    case supporters = 251
    case volunteerWork = 252
    case etc = 299
    
    func getTypeString() -> String {
        switch self {
        case .none:
            return "전체"
        case .supporters:
            return "서포터즈"
        case .volunteerWork:
            return "봉사활동"
        case .etc:
            return "기타"
        }
    }
}

enum InterestingFieldInternShip: Int, CaseIterable {
    case none = 0
    case developer = 104
    case designer = 112
    case marketer = 110
    case ceo = 101
    case media = 107
    case pm = 109
    case sales = 102
    case hr = 106
    case retail = 111
    case product = 103
    
    func getTypeString() -> String {
        switch self {
        case .none:
            return "전체"
        case .developer:
            return "개발"
        case .designer:
            return "디자인"
        case .marketer:
            return "마케팅/광고"
        case .ceo:
            return "경영/비즈니스"
        case .media:
            return "미디어"
        case .pm:
            return "엔지니어링/설계"
        case .sales:
            return "영업"
        case .hr:
            return "인사/교육"
        case .retail:
            return "고객서비스/리테일"
        case .product:
            return "제조/생산"
        }
    }
}
    

