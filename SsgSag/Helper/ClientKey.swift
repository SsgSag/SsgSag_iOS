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
    case adJustAppToken
    case naverBlogSearchId
    case naverBlogSearchSecret
    
    var getClienyKey: String {
        switch self {
        case .adBrixAppKey:
            return "UBVFGgtRykabVMFEdAlL0w"
        case .adBrixSecretKey:
            return "cMxXoU7sl06k2KZeHMbxdA"
        case .adJustAppToken:
            return "j5uza6tddv5s"
        case .naverBlogSearchId:
            return "3tdvTvoIm4hP2_IuDmV8"
        case .naverBlogSearchSecret:
            return "fM9uh5UxBy"
            
        }
        
    }
    
    
}
