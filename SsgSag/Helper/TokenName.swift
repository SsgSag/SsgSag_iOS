//
//  TokenName.swift
//  SsgSag
//
//  Created by admin on 20/05/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

enum TokenName {
    static let token = "SsgSagToken"
    
    static let tokenString = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJEb0lUU09QVCIsInVzZXJfaWR4Ijo2OTd9.9JZLLIsl9MGweSqSyXYuXSoyjhzur34hxPhWf3Jm85c"
}

enum AdjustTokenName {
    case TUTORIALS_OPEN
    case TUTORIALS_COMPLETE
    case SWIPE_SUCCESS
    case COMPLETE_REGISTRATION
    case CUSTOMIZE_FILTER
    case REGISTRATION_OPEN
    
    var getTokenString: String {
        switch self {
        case .TUTORIALS_OPEN:
            return "wwkfvo"
        case .TUTORIALS_COMPLETE:
            return "iy1h7x"
        case .SWIPE_SUCCESS:
            return "j8ehc8"
        case .COMPLETE_REGISTRATION:
            return "xzagyy"
        case .CUSTOMIZE_FILTER:
            return "i499qb"
        case .REGISTRATION_OPEN:
            return "pj08ph"
        }
    }
}
