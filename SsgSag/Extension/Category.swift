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
    case act = 1
    case club = 2
    case notice = 3
    case recruit = 4
    case etc = 5
    case edu = 7
    case scholar = 8
    
    func categoryString() -> String {
        switch self {
        case .contest:
            return "공모전"
        case .act:
            return "대외활동"
        case .club:
            return "동아리"
        case .notice:
            return "교내공지"
        case .recruit:
            return "인턴"
        case .etc:
            return "기타"
        case .edu:
            return "교육/강연"
        case .scholar:
            return "장학금/지원"
        }
    }
    
    func categoryColors() -> UIColor {
        switch self {
        case .contest:
            return #colorLiteral(red: 0.2039215686, green: 0.4274509804, blue: 0.9529411765, alpha: 1)
        case .act:
            return #colorLiteral(red: 0.3725490196, green: 0.1490196078, blue: 0.8039215686, alpha: 1)
        case .club:
            return #colorLiteral(red: 0.968627451, green: 0.7137254902, blue: 0.1921568627, alpha: 1)
        case .notice:
            return .white
        case .recruit:
            return #colorLiteral(red: 0.9960784314, green: 0.4274509804, blue: 0.4274509804, alpha: 1)
        case .edu:
            return #colorLiteral(red: 0.9921568627, green: 0.5607843137, blue: 0.2980392157, alpha: 1)
        case .scholar:
            return #colorLiteral(red: 0.1803921569, green: 0.7411764706, blue: 0.4784313725, alpha: 1)
        case .etc:
            return #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        }
    }
}
