//
//  TabbarServiceProtocol.swift
//  SsgSag
//
//  Created by 이혜주 on 27/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

protocol TabbarService: class {
    func requestIsInUpdateServer(
        completionHandler: @escaping (DataResponse<UpdateNetworkModel>) -> Void
    )
}
