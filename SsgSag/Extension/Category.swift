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
            return #colorLiteral(red: 0.2039215686, green: 0.4274509804, blue: 0.9529411765, alpha: 1)
        case .activity:
            return #colorLiteral(red: 0.9960784314, green: 0.4274509804, blue: 0.4274509804, alpha: 1)
        case .club:
            return #colorLiteral(red: 0.968627451, green: 0.7137254902, blue: 0.1921568627, alpha: 1)
        case .school:
            return #colorLiteral(red: 0.3803921569, green: 0.3803921569, blue: 0.3803921569, alpha: 1)
        case .career:
            return #colorLiteral(red: 0.3725490196, green: 0.1490196078, blue: 0.8039215686, alpha: 1)
        case .others:
            return #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        }
    }
    
    var calendarFilterNumber: Int {
        switch self {
        case .contest:
            return 2
        case .activity:
            return 3
        case .club:
            return 4
        default:
            return -1
        }
    }
    
}
