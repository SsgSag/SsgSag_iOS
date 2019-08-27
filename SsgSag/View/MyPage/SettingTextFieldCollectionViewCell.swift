//
//  SettingTextFieldCollectionViewCell.swift
//  SsgSag
//
//  Created by 이혜주 on 23/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

protocol PasswordDelegate: class {
    func changePassword()
}

class SettingTextFieldCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: PasswordDelegate?
    
    @IBOutlet private weak var settingTitleLabel: UILabel!
    
    @IBOutlet weak var settingTextField: UITextField!
    
    @IBOutlet weak var changeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // 비밀번호 변경 버튼 선택시
    @IBAction func touchUpChangeButton(_ sender: UIButton) {
        delegate?.changePassword()
    }
    
    func setupCell(title: String, placeholder: String, text: String) {
        settingTitleLabel.text = title
        settingTextField.placeholder = placeholder
        settingTextField.text = text
    }
    
    func setupPasswordCell(title: String, placeholder: String, text: String) {
        settingTitleLabel.text = title
        settingTextField.isUserInteractionEnabled = false
        settingTextField.placeholder = placeholder
        settingTextField.text = text
        settingTextField.textContentType = .password
    }
    
    func setupUnalterableCell(title: String, data: String) {
        settingTitleLabel.text = title
        settingTextField.isUserInteractionEnabled = false
        settingTextField.placeholder = data
        changeButton.isHidden = true
    }
}
