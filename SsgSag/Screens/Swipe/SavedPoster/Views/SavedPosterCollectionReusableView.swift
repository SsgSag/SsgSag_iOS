//
//  SavedPosterCollectionReusableView.swift
//  SsgSag
//
//  Created by  on 21/02/2020.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit

class SavedPosterCollectionReusableView: UICollectionReusableView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpLayout() {
        addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(
            equalTo: leadingAnchor, constant: 24).isActive = true
        titleLabel.topAnchor.constraint(
            equalTo: topAnchor).isActive = true
    }
  
}

class SavedPosterTempCollectionReusableView: UICollectionReusableView { }
