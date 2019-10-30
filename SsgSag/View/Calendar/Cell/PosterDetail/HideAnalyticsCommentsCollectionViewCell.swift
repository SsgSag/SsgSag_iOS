//
//  HideAnalyticsCommentsCollectionViewCell.swift
//  SsgSag
//
//  Created by 이혜주 on 16/08/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class HideAnalyticsCommentsCollectionViewCell: UICollectionViewCell {

    var callBack: (() -> ())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func touchUpGoToSignUpButton(_ sender: UIButton) {
        callBack?()
    }
}
