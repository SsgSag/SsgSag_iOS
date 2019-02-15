//
//  ConfirmProfileVC.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 10..
//  Copyright © 2019년 wndzlf. All rights reserved.
//

import UIKit

class ConfirmProfileVC: UIViewController, UITextFieldDelegate {
    
    var name: String = ""
    var nickName: String = ""
    var password: String = ""
    var gender: String = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var birthField: UITextField!
    @IBOutlet weak var nickNameField: UITextField!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var stackViewConstraint:  NSLayoutConstraint! //289
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.isUserInteractionEnabled = false

//        self.navigationItem.setHidesBackButton(true, animated: true)
        setBackBtn( color: .black)
        setNavigationBar(color: .white)
        
        nameField.delegate = self
        birthField.delegate = self
        nickNameField.delegate = self
        nickNameField.returnKeyType = .done
        
        nameField.tag = 1
        birthField.tag = 2
        nickNameField.tag = 3
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.nameField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        let nextTag = textField.tag + 1
        
        if let nextResponder =  self.view.viewWithTag(nextTag){
            
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }

        return true
    }
    
    @IBAction func touchUpNextButton(_ sender: Any) {
        if birthField.text?.count == 6 {
            let storyboard = UIStoryboard(name: "SignupStoryBoard", bundle: nil)
            let SchoolInfoVC = storyboard.instantiateViewController(withIdentifier: "SchoolInfoVC") as! SchoolInfoVC
            
            SchoolInfoVC.name = nameField.text ?? ""
            SchoolInfoVC.birth = birthField.text ?? ""
            SchoolInfoVC.nickName = nickNameField.text ?? ""
            SchoolInfoVC.gender = gender
            
            self.navigationController?.pushViewController(SchoolInfoVC, animated: true)
        } else {
            simpleAlert(title: "잘못된 형식입니다", message: "생년월일은 970219, \n닉네임은 영한혼용하지 말아주십시요ㅗ....")
            birthField.text = ""
        }
    }
    
    @IBAction func touchUpMaleButton(_ sender: UIButton) {
        femaleButton.isSelected = false
        femaleButton.setImage(UIImage(named: "btFemaleUnactive"), for: .normal)
        if maleButton.isSelected {
            self.gender = "male"
            maleButton.isUserInteractionEnabled = false
            maleButton.setImage(UIImage(named: "btMaleUnactive"), for: .normal)
        } else {
//            self.gender = "female"
            maleButton.isSelected = true
            maleButton.setImage(UIImage(named: "btMaleActive"), for: .normal)
        }
        checkInformation(self)
    }
    
    @IBAction func touchUpFemalButton(_ sender: UIButton) {
        maleButton.isSelected = false
        maleButton.setImage(UIImage(named: "btMaleUnactive"), for: .normal)
        
        if femaleButton.isSelected {
            self.gender = "female"
            femaleButton.isSelected = false
            femaleButton.setImage(UIImage(named: "btFemaleUnactive"), for: .normal)
        } else {
//            self.gender = "male"
            femaleButton.isSelected = true
            femaleButton.setImage(UIImage(named: "btFemaleActive"), for: .normal)
        }
        checkInformation(self)
    }
    
    @IBAction func touchUpCheckBoxButton(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            sender.setImage(UIImage(named: "btCheckUnactive"), for: .normal)
        } else {
            sender.isSelected = true
            sender.setImage(UIImage(named: "btCheckActive"), for: .normal)
        }
        checkInformation(self)
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        checkInformation(self)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("textfieldshouldBeginEditing")
        checkInformation(self)
        return true
    }
    
     @objc func checkInformation(_ sender: Any) {
        if (nameField.hasText && birthField.hasText && nickNameField.hasText && checkBoxButton.isSelected) {
            if (maleButton.isSelected || femaleButton.isSelected) {
                nextButton.isUserInteractionEnabled = true
                nextButton.setImage(UIImage(named: "btNextActive"), for: .normal)
            } else {
                nextButton.isUserInteractionEnabled = false
                nextButton.setImage(UIImage(named: "btNextUnactive"), for: .normal)
            }
        } else {
            nextButton.isUserInteractionEnabled = false
            nextButton.setImage(UIImage(named: "btNextUnactive"), for: .normal)
        }
    }
}

