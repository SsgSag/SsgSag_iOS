//
//  NetworkResult.swift
//  SsgSag
//
//  Created by CHOMINJI on 2018. 12. 31..
//  Copyright © 2018년 wndzlf. All rights reserved.
//

import Foundation

enum NetworkResult<T> {
    case success(T)
    case error(Error)
}

