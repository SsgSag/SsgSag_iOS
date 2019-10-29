//
//  myPageMenuTableViewCell.swift
//  SsgSag
//
//  Created by 이혜주 on 22/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class myPageMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var menuImageView: UIImageView!
    
    @IBOutlet weak var menuTitleLabel: UILabel!
    
    private let menuTitleString: [String] = ["나의 이력", "알림 설정", "공지사항", "문의하기"]
    
    private let menuImageString: [String] = ["ic_jobSetting", "ic_alarm", "ic_noticeSetting", "ic_inquirySetting"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(row: Int) {
        menuTitleLabel.text = menuTitleString[row]
        menuImageView.image = UIImage(named: menuImageString[row])
    }
    
}
