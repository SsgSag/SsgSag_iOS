//
//  Array.swift
//  SsgSag
//
//  Created by bumslap on 29/12/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
