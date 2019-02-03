//
//  categoryColor.swift
//  SsgSag
//
//  Created by CHOMINJI on 03/02/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//


import UIKit

enum categoryIdx : String {
    case contest
    case activity
    case club
    case school
    case career
    case extra
    
    func simpleDescription() -> UIColor {
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
        case .extra:
            return UIColor.rgb(red: 255, green: 160, blue: 160)
        default:
            return .clear
        }
    }
}
