//
//  ReviewPageCollectionViewCell.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/23.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit

class ReviewPageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var tabLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    var onFocus: Bool = false {
        willSet {
            if newValue {
                self.lineView.backgroundColor = .cornFlower
                self.tabLabel.font = UIFont.fontWithName(type: .medium, size: 14)
                self.tabLabel.textColor = .cornFlower
            } else {
                self.lineView.backgroundColor = .reviewDeselectLineGray
                self.tabLabel.font = UIFont.fontWithName(type: .regular, size: 14)
                self.tabLabel.textColor = .reviewDeselectGray
            }
        }
    }
    
    override func awakeFromNib() {
        
    }
}
