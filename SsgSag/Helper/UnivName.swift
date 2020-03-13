//
//  UnivName.swift
//  SsgSag
//
//  Created by 남수김 on 2020/03/13.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import Foundation

class UnivName {
    private init() {}
    static let shared = UnivName()
    
    var univ: [String: [String]] = [:]
    
    func requestUnivList() {
        UnivService().requestUnivInfoList() { univList in
            guard let univList = univList else {
                return
            }
            univList.forEach{
                let key = $0.학교명
                let value = $0.학과명
                self.univ[key] = value
            }
        }
    }
}
