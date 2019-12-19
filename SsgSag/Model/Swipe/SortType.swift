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
