//
//  AdvertisementCollectionViewCell.swift
//  SsgSag
//
//  Created by 남수김 on 2020/03/24.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit

class AdvertisementCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    var imgString: String? {
        willSet {
            guard let imgString = newValue, let imgURL = URL(string: imgString) else {
                return
            }
            imgView.kf.indicatorType = .activity
            imgView.kf.setImage(with: imgURL, options: [.transition(.fade(0.2)), .cacheOriginalImage])
        }
    }
    
    override func awakeFromNib() {
       
    }
    
}
