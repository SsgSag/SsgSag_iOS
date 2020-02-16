//
//  ResponseModel.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/11.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation


struct ResponseSimpleResult<T: Codable>: Codable {
    var status: Int
    var message: String
    var data: T?
}


struct ResponseArrayResult<T: Codable>: Codable {
    var status: Int
    var message: String
    var data: [T]?
}
