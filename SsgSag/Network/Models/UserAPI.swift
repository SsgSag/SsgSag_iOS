//
//  UserAPI.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 9..
//  Copyright © 2019년 wndzlf. All rights reserved.
//

import Foundation

class UserAPI {
    
    private init() { }
    
    static let sharedInstance = UserAPI()
    
    private let baseURLString = "http://ssgsag-alb-2141317761.ap-northeast-2.elb.amazonaws.com"
//    private let baseURLString = "http://13.209.77.133:8082"
    
    func getBaseString() -> String {
        return baseURLString
    }
    
    func getURL(_ getString: String) -> URL? {
        let urlString = baseURLString + getString
        
        guard let resultURL = URL(string: urlString) else { return nil }
        
        return resultURL
    }
    
}
