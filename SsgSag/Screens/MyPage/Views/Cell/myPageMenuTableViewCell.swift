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
    
    private let menuTitleString: [String] = ["나의 후기", "나의 이력", "알림 설정", "공지사항", "문의하기", "서비스 정보", "계정설정"]
    
    private let menuImageString: [String] = ["icReviewSettings", "ic_jobSetting", "icAlarm", "icNotice", "icReport", "icServiceInfo", "settings"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(row: Int) {
        menuTitleLabel.text = menuTitleString[row]
        menuImageView.image = UIImage(named: menuImageString[row])
    }
    
}
