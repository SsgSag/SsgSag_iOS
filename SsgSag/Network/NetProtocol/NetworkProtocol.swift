//
//  Network.swift
//  SsgSag
//
//  Created by 이혜주 on 27/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation
import RxSwift

protocol Network {
    func dispatch(
        request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    )
}

protocol RxNetwork {
    func dispatch(request: URLRequest) -> Observable<Data>
}

