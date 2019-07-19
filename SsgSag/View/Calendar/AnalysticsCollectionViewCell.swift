//
//  AnalysticsCollectionViewCell.swift
//  SsgSag
//
//  Created by 이혜주 on 18/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class AnalysticsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var analyticsStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure() {
        analyticsStackView.subviews[0]
    }

}
