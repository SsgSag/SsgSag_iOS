//
//  HTTPTask.swift
//  SsgSag
//
//  Created by admin on 12/04/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String:String]

public enum HTTPTask {
    case request
    
    case requestParameters(bodyParameters: Parameters? , urlParameters: Parameters?)
    
    case requestParametersAndHeaders(bodyParameters: Parameters?, urlParameters: Parameters?,
        additionHeaders: HTTPHeaders?)
}
