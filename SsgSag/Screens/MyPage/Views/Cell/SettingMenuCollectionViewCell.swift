//
//  SettingMenuCollectionViewCell.swift
//  SsgSag
//
//  Created by 이혜주 on 23/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class SettingMenuCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var menuImageView: UIImageView!
    
    @IBOutlet weak var menuTitleLabel: UILabel!
    
    private let menuTitleString: [String] = ["로그아웃", "회원탈퇴"]
    
    private let menuImageString: [String] = ["ic_logOut", "ic_membershipOut"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(row: Int) {
        menuTitleLabel.text = menuTitleString[row]
        menuImageView.image = UIImage(named: menuImageString[row])
    }
}
