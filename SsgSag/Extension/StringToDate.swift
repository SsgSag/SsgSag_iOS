//
//  StringToDate.swift
//  SsgSag
//
//  Created by admin on 06/05/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

extension String {
    var Date: Date {
        
        let dateFormatter = DateFormatter.genericDateFormatter
        
        guard let date = dateFormatter.date(from: self) else {return .init()}
        
        return date
    }
}
