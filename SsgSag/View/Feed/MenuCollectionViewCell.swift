//
//  MenuCollectionViewCell.swift
//  SsgSag
//
//  Created by 이혜주 on 14/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.7333333333, green: 0.7333333333, blue: 0.7333333333, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    override var isHighlighted: Bool {
        didSet {
            titleLabel.textColor = isHighlighted ? #colorLiteral(red: 0.3843137255, green: 0.4156862745, blue: 1, alpha: 1) : #colorLiteral(red: 0.7333333333, green: 0.7333333333, blue: 0.7333333333, alpha: 1)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected ? #colorLiteral(red: 0.3843137255, green: 0.4156862745, blue: 1, alpha: 1) : #colorLiteral(red: 0.7333333333, green: 0.7333333333, blue: 0.7333333333, alpha: 1)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(titleLabel)
        
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
