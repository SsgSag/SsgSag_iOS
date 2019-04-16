//
//  ParameterEncoding.swift
//  SsgSag
//
//  Created by admin on 12/04/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

public typealias Parameters = [String:Any]

/// performs one function which is to encode parameters
public protocol ParameterEncoder {
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

public enum NetworkError: String, Error {
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
}
