//
//  AdmissionCollectionViewCell.swift
//  SsgSag
//
//  Created by 이혜주 on 16/08/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class AdmissionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var admissionTextField: UITextField!
    
    lazy var admissionPickerView = UIPickerView()
    var admissionPickOption: [String] = []
    
    lazy var admissionDoneButton = UIBarButtonItem(title: "Done",
                                                   style: .plain,
                                                   target: self,
                                                   action: #selector(touchUpAdmissionDoneButton))
    
    lazy var flexible
        = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                          target: self,
                          action: nil)
    
    private let dropDownImageView
        = UIImageView(image: UIImage(named: "ic_dropDownColor"))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        admissionPickerView.delegate = self
        admissionPickerView.dataSource = self
        
        setupAdmissionOption()
        setupLayout()
    }
    
    private func setupLayout() {
        let admissionToolBar = UIToolbar()
        admissionToolBar.barStyle = .default
        admissionToolBar.isTranslucent = true
        admissionToolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        admissionToolBar.sizeToFit()
        admissionToolBar.isUserInteractionEnabled = true
        admissionToolBar.setItems([flexible, admissionDoneButton], animated: false)
        admissionDoneButton.tintColor = #colorLiteral(red: 0.4603668451, green: 0.5182471275, blue: 1, alpha: 1)
        
        admissionTextField.inputView = admissionPickerView
        admissionTextField.inputAccessoryView = admissionToolBar
        
        admissionTextField.rightViewMode = .always
        admissionTextField.rightView = dropDownImageView
    }

    private func setupAdmissionOption() {
        let currentDate = Date()
        let year = Calendar.current.component(.year, from: currentDate)
        
        for admissionYear in (1990...year).reversed() {
            admissionPickOption.append(String(admissionYear))
        }
    }
    
    @objc func touchUpAdmissionDoneButton() {
        admissionTextField.resignFirstResponder()
    }
    
}

extension AdmissionCollectionViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return admissionPickOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return admissionPickOption[row]
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        admissionTextField.text = admissionPickOption[row]
    }
}
