//
//  StringToDate.swift
//  SsgSag
//
//  Created by admin on 06/05/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

extension String {
    var Date: Date {
        
        let dateFormatter = DateFormatter.genericDateFormatter
        
        guard let date = dateFormatter.date(from: self) else {return .init()}
        
        return date
    }
    
    func estimatedFrame(font: UIFont) -> CGRect {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        label.text = self
        label.font = font
        label.sizeToFit()
        return label.bounds
    }
}


