//
//  StudentNumberCollectionViewCell.swift
//  SsgSag
//
//  Created by 이혜주 on 16/08/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class StudentNumberCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var studentNumberTextField: UITextField!
    
    lazy var studentNumberPickerView = UIPickerView()
    var studentNumberPickOption: [String] = []
    
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
        
        studentNumberPickerView.delegate = self
        studentNumberPickerView.dataSource = self
        
        setupAdmissionOption()
        setupLayout()
    }
    
    private func setupLayout() {
        let studentNumberToolBar = UIToolbar()
        studentNumberToolBar.barStyle = .default
        studentNumberToolBar.isTranslucent = true
        studentNumberToolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        studentNumberToolBar.sizeToFit()
        studentNumberToolBar.isUserInteractionEnabled = true
        studentNumberToolBar.setItems([flexible, admissionDoneButton], animated: false)
        admissionDoneButton.tintColor = #colorLiteral(red: 0.4603668451, green: 0.5182471275, blue: 1, alpha: 1)
        
        studentNumberTextField.inputView = studentNumberPickerView
        studentNumberTextField.inputAccessoryView = studentNumberToolBar
        
        studentNumberTextField.rightViewMode = .always
        studentNumberTextField.rightView = dropDownImageView
    }

    private func setupAdmissionOption() {
        let currentDate = Date()
        let year = Calendar.current.component(.year, from: currentDate) % 100
        
        for studentNumber in (year-10...year).reversed() {
            studentNumberPickOption.append("\(String(studentNumber))학번")
        }
    }
    
    @objc func touchUpAdmissionDoneButton() {
        studentNumberTextField.resignFirstResponder()
    }
    
}

extension StudentNumberCollectionViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return studentNumberPickOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return studentNumberPickOption[row]
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        studentNumberTextField.text = studentNumberPickOption[row]
    }
}
