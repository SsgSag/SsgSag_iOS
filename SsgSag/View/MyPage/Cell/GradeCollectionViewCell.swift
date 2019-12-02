//
//  GradeCollectionViewCell.swift
//  SsgSag
//
//  Created by 이혜주 on 16/08/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class GradeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var gradeTextField: UITextField!
    
    lazy var gradeDoneButton = UIBarButtonItem(title: "Done",
                                               style: .plain,
                                               target: self,
                                               action: #selector(touchUpGradeDoneButton))
    
    lazy var flexible
        = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                          target: self,
                          action: nil)
    
    private let dropDownImageView
        = UIImageView(image: UIImage(named: "ic_dropDownColor"))
    
    lazy var gradePickerView = UIPickerView()
    var gradePickOption: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        gradePickerView.delegate = self
        gradePickerView.dataSource = self
        
        setupGradePickOption()
        setupLayout()
    }
    
    private func setupGradePickOption() {
        for grade in 1...5 {
            gradePickOption.append("\(grade)학년")
        }
    }
    
    private func setupLayout() {
        let gradeToolBar = UIToolbar()
        gradeToolBar.barStyle = .default
        gradeToolBar.isTranslucent = true
        gradeToolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        gradeToolBar.sizeToFit()
        gradeToolBar.isUserInteractionEnabled = true
        gradeToolBar.setItems([flexible, gradeDoneButton], animated: false)
        gradeDoneButton.tintColor = #colorLiteral(red: 0.4603668451, green: 0.5182471275, blue: 1, alpha: 1)
    
        gradeTextField.inputView = gradePickerView
        gradeTextField.inputAccessoryView = gradeToolBar
        
        gradeTextField.rightViewMode = .always
        gradeTextField.rightView = dropDownImageView
    }
    
    @objc func touchUpGradeDoneButton() {
        gradeTextField.resignFirstResponder()
    }

}

extension GradeCollectionViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return gradePickOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return gradePickOption[row]
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        gradeTextField.text = gradePickOption[row]
    }
}
