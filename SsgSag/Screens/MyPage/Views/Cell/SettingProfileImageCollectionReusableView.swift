//
//  SettingProfileImageCollectionReusableView.swift
//  SsgSag
//
//  Created by 이혜주 on 23/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

protocol ShowImagePickerDelegate {
    func imagePickerShouldLoad()
}

class SettingProfileImageCollectionReusableView: UICollectionReusableView {
    var delegate: ShowImagePickerDelegate?
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setProfileImage(image: UIImage?) {
        guard let image = image else {
            return
        }
        profileImageView.image = image
    }
    
    @IBAction func touchUpSettingImageButton(_ sender: UIButton) {
        delegate?.imagePickerShouldLoad()
    }
}
