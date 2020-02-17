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
    
    func estimatedFrame(font: UIFont?) -> CGRect {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.text = self
        label.font = font
        label.sizeToFit()
        return label.bounds
    }
    
    func isValidEmail() -> Bool {
        let emailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        return predicate.evaluate(with: self)
    }
    
    func isValidPhone() -> Bool {
        let phoneRegex: String = "01([0-9])([0-9]{3,4})([0-9]{4})$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        
        return predicate.evaluate(with: self)
    }
}


