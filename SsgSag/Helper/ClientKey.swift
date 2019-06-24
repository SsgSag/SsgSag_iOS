//
//  ClientKey.swift
//  SsgSag
//
//  Created by admin on 14/06/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

enum ClientKey {
    case adBrixAppKey
    case adBrixSecretKey
    
    var getClienyKey: String {
        switch self {
        case .adBrixAppKey:
            return "StRs1sK4R0qZrnXER8pBmw"
        case .adBrixSecretKey:
            return "ZUTLqhtDYU2KKd2MUiwOkw"
        }
    }
    
}
