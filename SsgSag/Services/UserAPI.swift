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
    
    private let baseURLString = "http://52.78.86.179:8081"
    
    func getBaseString() -> String {
        return baseURLString
    }
    
    func getURL(_ getString: String) -> URL? {
        
        let urlString = baseURLString + getString
        
        guard let resultURL = URL(string: urlString) else { return nil }
        
        return resultURL
    }
    
}


