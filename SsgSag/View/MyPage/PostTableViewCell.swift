//
//  PostTableViewCell.swift
//  SsgSag
//
//  Created by 이혜주 on 22/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    private let contentsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func setupLayout() {
        addSubview(contentsLabel)
        
        contentsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 22).isActive = true
        contentsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22).isActive = true
        contentsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22).isActive = true
        contentsLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    func setContentsLabel(color: UIColor, size: CGFloat, text: String) {
        contentsLabel.font = UIFont.systemFont(ofSize: size)
        contentsLabel.textColor = color
        
//        guard let text = text else { return }
        contentsLabel.text = text
    }
}
