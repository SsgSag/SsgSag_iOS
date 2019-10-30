//
//  TabbarServiceProtocol.swift
//  SsgSag
//
//  Created by 이혜주 on 27/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

protocol TabbarService: class {
    func requestValidateServer(
        completionHandler: @escaping (DataResponse<ServerUpdateResponse>) -> Void
    )
}
