//
//  APIManager.swift
//  SsgSag
//
//  Created by CHOMINJI on 2018. 12. 31..
//  Copyright © 2018년 wndzlf. All rights reserved.
//

import Foundation

protocol APIManager {}

extension APIManager {
    static func url(_ path: String) -> String {
        return "http://13.209.212.209:8080" + path
    }
}
