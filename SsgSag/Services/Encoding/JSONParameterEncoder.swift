//
//  JSONParameterEncoder.swift
//  SsgSag
//
//  Created by admin on 12/04/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

public struct JSONParamterEncoder: ParameterEncoder {
    public static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonAsData
            if urlRequest.value(forHTTPHeaderField: "Content-type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
            }
        } catch {
            print(NetworkError.encodingFailed)
        }
    }
}
