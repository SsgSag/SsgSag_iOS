//
//  FormTextField.swift
//  SsgSag
//
//  Created by 이혜주 on 30/10/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class FormTextField: UITextField {
    let padding = UIEdgeInsets(top: 0,
                               left: 10,
                               bottom: 0,
                               right: 10)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
