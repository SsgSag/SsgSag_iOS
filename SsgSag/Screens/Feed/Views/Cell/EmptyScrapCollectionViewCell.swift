//
//  EmptyScrapCollectionViewCell.swift
//  SsgSag
//
//  Created by 이혜주 on 27/09/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class EmptyScrapCollectionViewCell: UICollectionViewCell {
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "저장한 뉴스가 없습니다"
        label.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(emptyLabel)
        
        emptyLabel.centerXAnchor.constraint(
            equalTo: centerXAnchor).isActive = true
        emptyLabel.centerYAnchor.constraint(
            equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
