//
//  ClubInfoDetailPhotoCollectionViewCell.swift
//  SsgSag
//
//  Created by 남수김 on 2020/02/18.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import Kingfisher

class ClubInfoDetailPhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 3
    }

    func bind(photoURLString: String) {
        let photoURL = URL(string: photoURLString)
        imageView.kf.setImage(with: photoURL, options: [.transition(.fade(0.3)), .cacheOriginalImage])
    }
}


extension ClubInfoDetailPhotoCollectionViewCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
