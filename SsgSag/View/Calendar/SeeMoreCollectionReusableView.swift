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
    @IBOutlet weak var seeMoreView: UIView!
    @IBOutlet weak var seeMoreViewHeightConstraint: NSLayoutConstraint!
    
    var callback: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func estimatedFrame(width: CGFloat, text: String, font: UIFont) -> CGRect {
        let size = CGSize(width: width, height: 1000) // temporary size
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size,
                                                   options: options,
                                                   attributes: [NSAttributedString.Key.font: font],
                                                   context: nil)
    }
    
    @IBAction func touchUpSeeMoreButton(_ sender: UIButton) {
        if seeMoreViewHeightConstraint.constant == 0 {
            contentsLabel.isHidden = false
            let collectionViewCellHeight = estimatedFrame(width: frame.width - 75,
                                                          text: contentsLabel.text ?? "",
                                                          font: UIFont.systemFont(ofSize: 12)).height

            seeMoreViewHeightConstraint.constant = collectionViewCellHeight + 50
        } else {
            contentsLabel.isHidden = true
            seeMoreViewHeightConstraint.constant = 0
        }
        callback?()
    }
}
