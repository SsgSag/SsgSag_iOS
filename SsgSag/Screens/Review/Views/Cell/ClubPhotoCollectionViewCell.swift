//
//  ClubPhotoCollectionViewCell.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/28.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import Kingfisher

class ClubPhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    let view = UIView()
    let label = UILabel()
    var imgString: String! {
        willSet {
            let imgURL = URL(string: newValue)
            self.imgView.kf.setImage(with: imgURL, options: [.transition(.fade(0.3)), .cacheOriginalImage])
        }
    }
    
    override func awakeFromNib() {

    }
    
    func hideView() {
        self.view.isHidden = true
    }
    
    // 사진이 더 있는경우 표시
    func morePhotoView(moreCount: Int) {
        self.view.isHidden = false
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        label.textAlignment = .center
        label.text = "+\(moreCount)장"
        label.font = UIFont.fontWithName(type: .regular, size: 12)
        label.sizeToFit()
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
    }
}
