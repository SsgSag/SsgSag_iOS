//
//  SettingTextFieldCollectionViewCell.swift
//  SsgSag
//
//  Created by 이혜주 on 23/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class SettingTextFieldCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var settingTitleLabel: UILabel!
    
    @IBOutlet weak var settingTextField: UITextField!
    
    @IBOutlet weak var changeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func touchUpChangeButton(_ sender: UIButton) {
    }
    
    func setupCell(title: String, placeholder: String) {
        settingTitleLabel.text = title
        settingTextField.placeholder = placeholder
    }
    
    func setupUnalterableCell(title: String, data: String) {
        settingTitleLabel.text = title
        settingTextField.isUserInteractionEnabled = false
        settingTextField.placeholder = data
        changeButton.isHidden = true
    }
}
