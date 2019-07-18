//
//  ContactInfoCollectionViewCell.swift
//  SsgSag
//
//  Created by 이혜주 on 18/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class ContactInfoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var partnerPhoneNumberLabel: UILabel!
    
    @IBOutlet weak var partnerEmailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(phoneNumber: String,
                   email: String) {
        partnerPhoneNumberLabel.text = "전화번호: " + phoneNumber
        
        partnerEmailLabel.text = "이메일: " + email
    }

}
