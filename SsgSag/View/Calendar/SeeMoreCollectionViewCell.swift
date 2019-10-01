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
    @IBOutlet weak var seeMoreHeightConstraint: NSLayoutConstraint!
    
    var isFolding: Bool = true
    var callback: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(contents: String,
                   height: CGFloat) {
        seeMoreContentsLabel.text = contents
        seeMoreHeightConstraint.constant = height
    }

    @IBAction func touchUpSeeMoreButton(_ sender: UIButton) {
        callback?()
    }
}
