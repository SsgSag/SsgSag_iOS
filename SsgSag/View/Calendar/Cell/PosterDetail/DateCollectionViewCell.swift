//
//  DateCollectionViewCell.swift
//  SsgSag
//
//  Created by 이혜주 on 01/11/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ddayButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(_ date: String,
                   dday: Int?) {
        dateLabel.text = date
        
        guard let dday = dday else {
            return
        }
        
        guard dday >= 0 else {
            ddayButton.isHidden = true
            return
        }
        
        ddayButton.setTitle("D-\(dday)", for: .normal)
    }

}
