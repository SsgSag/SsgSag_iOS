//
//  SortType.swift
//  SsgSag
//
//  Created by 이혜주 on 19/12/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

enum HeaderCategoryType {
    case contest(String)
    case activity(String)
    case allClub(String)
    case internalClub(String)
    case internshipCompanyType(String)
    case internshipInteresting(String)
    
    func getTypeNumber() -> Int {
        switch self {
        case .contest:
            return 0
        case .activity:
            return 1
        case .allClub:
            return 2
        case .internshipCompanyType, .internshipInteresting:
            return 4
        case .internalClub:
            return 6
        }
    }
}

enum SortType: Int {
    case latest = 2
    case deadline = 1
    case popular = 0
    
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
    case literature = 204
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
        case .literature:
            return "문학/시나리오"
        case .design:
            return "디자인"
        case .contents:
            return "영상/콘텐츠"
        case .it:
            return "IT/SW"
        case .startUp:
            return "창업/스타트업"
        case .finance:
            return "금융/경제"
        case .etc:
            return "기타"
        }
    }
}

enum InterstingClubType: Int, CaseIterable {
    case none = 0
    case literature = 401
    case sports = 402
    case trip = 403
    case music = 404
    case volunteer = 405
    case study = 406
    case language = 407
    case startUp = 408
    case relationship = 409
    case it = 410
    case etc = 411
    
    func getTypeString() -> String {
        switch self {
        case .none:
            return "전체"
        case .literature:
            return "문화생활"
        case .sports:
            return "스포츠"
        case .trip:
            return "여행"
        case .music:
            return "음악/예술"
        case .volunteer:
            return "봉사"
        case .study:
            return "스터디/학회"
        case .language:
            return "어학"
        case .startUp:
            return "창업"
        case .relationship:
            return "친목"
        case .it:
            return "IT/공학"
        case .etc:
            return "기타"
        }
    }
}

enum InterestingFieldActivity: String, CaseIterable {
    case none = "0"
    case supporters = "251"
    case bigCompanyVolunteerWork = "10000,251"
    case publicCompanyVolunteerWork = "50000,251"
    case volunteerWork = "252"
    case abroadVolunteer = "254"
    case reviewer = "255"
    case etc = "299"

    func getTypeString() -> String {
        switch self {
        case .none:
            return "전체"
        case .supporters:
            return "서포터즈"
        case .bigCompanyVolunteerWork:
            return "대기업 서포터즈"
        case .publicCompanyVolunteerWork:
            return "공사/공기업 서포터즈"
        case .volunteerWork:
            return "봉사활동"
        case .reviewer:
            return "리뷰/체험단"
        case .abroadVolunteer:
            return "해외봉사/탐방"
        case .etc:
            return "기타"
        }
    }
}

enum CompanyTypeInternShip: Int, CaseIterable {
    case none = 0
    case publicCompany = 50000
    case bigCompany = 10000
    case middleCompany = 20000
    case foreignCompany = 60000
    case smallCompany = 30000
    case startUp = 40000
    case etc = 95000
    
    func getTypeString() -> String {
        switch self {
        case .none:
            return "전체"
        case .publicCompany:
            return "공사/공기업"
        case .bigCompany:
            return "대기업"
        case .middleCompany:
            return "중견기업"
        case .foreignCompany:
            return "외국계기업"
        case .smallCompany:
            return "중소기업"
        case .startUp:
            return "스타트업"
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
    

