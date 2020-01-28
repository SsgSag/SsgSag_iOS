//
//  String+Extension.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/28.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation

extension String {
    func removeComma() -> [String] {
        let sub = self.split(separator: ",")
        let stringArr = sub.map { String($0) }
        return stringArr
    }
}
