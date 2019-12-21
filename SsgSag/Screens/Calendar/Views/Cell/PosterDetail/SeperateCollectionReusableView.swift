//
//  SeperateCollectionReusableView.swift
//  SsgSag
//
//  Created by 이혜주 on 01/11/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class SeperateCollectionReusableView: UICollectionReusableView {
    let seperateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    private func setupLayout() {
        backgroundColor = .white
        
        addSubview(seperateView)
        
        seperateView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        seperateView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        seperateView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        seperateView.heightAnchor.constraint(equalToConstant: 7).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
