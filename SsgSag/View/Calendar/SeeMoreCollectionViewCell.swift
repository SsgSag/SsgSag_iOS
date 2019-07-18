//
//  SeeMoreCollectionViewCell.swift
//  SsgSag
//
//  Created by 이혜주 on 18/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class SeeMoreCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var seeMoreContentsLabel: UILabel!
    
    var isFolding: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(contents: String) {
        seeMoreContentsLabel.text = contents
    }

}
