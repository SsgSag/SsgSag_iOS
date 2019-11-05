//
//  SeeMoreCollectionReusableView.swift
//  SsgSag
//
//  Created by 이혜주 on 01/10/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class SeeMoreCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var contentsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(_ contentsString: String) {
        let attrString = NSMutableAttributedString(string: contentsString)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                value: paragraphStyle,
                                range: NSMakeRange(0, attrString.length))
        contentsLabel.attributedText = attrString
        
        contentsLabel.text = contentsString
    }
}
