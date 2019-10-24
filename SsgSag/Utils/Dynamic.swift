//
//  Dynamic.swift
//  SsgSag
//
//  Created by 이혜주 on 23/10/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

class Dynamic<T> {
    
    var handler: (T) -> Void = { _ in }
    
    var value: T {
        didSet {
            handler(value)
        }
    }
    
    func addObserver(completionHandler: @escaping ((T)->())) {
        self.handler = completionHandler
    }
    
    init(_ v: T) {
        value = v
    }
}
