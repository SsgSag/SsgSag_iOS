//
//  categoryColor.swift
//  SsgSag
//
//  Created by CHOMINJI on 03/02/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

enum PosterCategory: Int {
    case contest = 0
    case activity = 1
    case club = 2
    case school = 3
    case career = 4
    case others = 5
    
    func categoryString() -> String {
        switch self {
        case .contest:
            return "공모전"
        case .activity:
            return "대외활동"
        case .club:
            return "동아리"
        case .school:
            return "교내공지"
        case .career:
            return "채용"
        case .others:
            return "기타"
        }
    }
    
    func categoryColors() -> UIColor {
        switch self {
        case .contest:
            return UIColor.rgb(red: 97, green: 118, blue: 221)
        case .activity:
            return UIColor.rgb(red: 184, green: 122, blue: 242)
        case .club:
            return UIColor.rgb(red: 254, green: 109, blue: 109)
        case .school:
            return UIColor.rgb(red: 7, green: 166, blue: 255)
        case .career:
            return UIColor.rgb(red: 208, green: 175, blue: 240)
        case .others:
            return UIColor.rgb(red: 255, green: 160, blue: 160)
        }
    }
}
