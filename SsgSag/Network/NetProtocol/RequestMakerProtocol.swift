//
//  RequestMakerProtocol.swift
//  SsgSag
//
//  Created by 이혜주 on 27/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

protocol RequestMakerProtocol {
    func makeRequest(url: URL,
                     method: HTTPMethod,
                     header: [String: String]?,
                     body: Data?) -> URLRequest?
}
