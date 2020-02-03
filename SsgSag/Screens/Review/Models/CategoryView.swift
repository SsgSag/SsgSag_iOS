//
//  CategoryView.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/03.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit

class CategoryView: UILabel {
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += 8
        contentSize.width += 8
        return contentSize
    }
    
    convenience init(text: String) {
        self.init(frame: .zero)
        
        configure(text: text)
    }
    
    func configure(text: String) {
        
        self.backgroundColor = #colorLiteral(red: 0.3960784314, green: 0.431372549, blue: 0.9411764706, alpha: 0.08)
        self.layer.cornerRadius = 3
        self.font = UIFont(name: "Apple SD 산돌고딕 Neo", size: 10.0)
        self.textColor = .cornFlower
        self.text = text
        self.textAlignment = .center
    }
}

class CategoryList: UIStackView {
    override func addSubview(_ subview: UIView) {
        let contraintLast = self.subviews.last?.trailingAnchor ?? self.leadingAnchor
        super.addSubview(subview)
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        subview.leadingAnchor.constraint(equalTo: contraintLast, constant: 4).isActive = true
    }
}
