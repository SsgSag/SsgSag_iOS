//
//  ConfirmProfileVC.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 10..
//  Copyright © 2019년 wndzlf. All rights reserved.
//

import UIKit

class ConfirmProfileVC: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    private var name: String = ""
    
    private var nickName: String = ""
    
    private var password: String = ""
    
    private var gender: String = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var birthField: UITextField!
    
    @IBOutlet weak var nickNameField: UITextField!
    
    @IBOutlet weak var maleButton: UIButton!
    
    @IBOutlet weak var femaleButton: UIButton!
    
    @IBOutlet weak var checkBoxButton: UIButton!
    
    @IBOutlet weak var nextButton: GradientButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.isUserInteractionEnabled = false
        
        iniGestureRecognizer()
        
        let backButton = UIBarButtonItem(image: UIImage(named: "icArrowBack"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(self.back))
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        setNavigationBar(color: .white)
        
        nameField.delegate = self
        birthField.delegate = self
        nickNameField.delegate = self
        nickNameField.returnKeyType = .done
        
        nameField.tag = 1
        birthField.tag = 2
        nickNameField.tag = 3
    }
    
    private func iniGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTabMainView(_:)))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTabMainView(_ sender: UITapGestureRecognizer){
        nameField.resignFirstResponder()
        nickNameField.resignFirstResponder()
        birthField.resignFirstResponder()
    }
    
    //FIXME: - present..하지 마시오,,,,,
    @objc func back(){
        let storyboard = UIStoryboard(name: StoryBoardName.login, bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "Login")
        present(loginVC, animated: false, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        let nextTag = textField.tag + 1
        
        if let nextResponder = self.view.viewWithTag(nextTag){
            
            nextResponder.becomeFirstResponder()
            
        } else {
            textField.resignFirstResponder()
        }

        return true
    }
    
    @IBAction func touchUpNextButton(_ sender: Any) {
        if birthField.text?.count == 6 {
            let storyboard = UIStoryboard(name: StoryBoardName.signup, bundle: nil)
            let SchoolInfoVC = storyboard.instantiateViewController(withIdentifier: "SchoolInfoVC") as! SchoolInfoVC
            
            SchoolInfoVC.name = nameField.text ?? ""
            SchoolInfoVC.birth = birthField.text ?? ""
            SchoolInfoVC.nickName = nickNameField.text ?? ""
            SchoolInfoVC.gender = gender
            
            self.navigationController?.pushViewController(SchoolInfoVC, animated: true)
            
        } else {
            simpleAlert(title: "잘못된 형식입니다", message: "생년월일은 주민번호앞자리 \n닉네임은 영한혼용하지 말아주세요.")
            birthField.text = ""
        }
    }
    
    @IBAction func touchUpMaleButton(_ sender: UIButton) {
        femaleButton.isSelected = false
        femaleButton.setImage(UIImage(named: "btFemaleUnactive"), for: .normal)
        if maleButton.isSelected {
            self.gender = ""
            maleButton.isSelected = false
            maleButton.setImage(UIImage(named: "btMaleUnactive"), for: .normal)
        } else {
            self.gender = "male"
            maleButton.isSelected = true
            maleButton.setImage(UIImage(named: "btMaleActive"), for: .normal)
        }
        checkInformation(self)
    }
    
    @IBAction func touchUpFemalButton(_ sender: UIButton) {
        maleButton.isSelected = false
        maleButton.setImage(UIImage(named: "btMaleUnactive"), for: .normal)
        
        if femaleButton.isSelected {
            self.gender = ""
            femaleButton.isSelected = false
            femaleButton.setImage(UIImage(named: "btFemaleUnactive"), for: .normal)
        } else {
            self.gender = "female"
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
        
        guard nameField.hasText && birthField.hasText && nickNameField.hasText && checkBoxButton.isSelected else {
            
            nextButton.isUserInteractionEnabled = false
            
            nextButton.topColor = .lightGray
            nextButton.bottomColor = .white
            
            return
        }
        
        guard maleButton.isSelected || femaleButton.isSelected else {
            nextButton.isUserInteractionEnabled = false
            
            nextButton.topColor = .lightGray
            nextButton.bottomColor = .white
            
            return
        }
        
        nextButton.isUserInteractionEnabled = true
        
        nextButton.topColor = #colorLiteral(red: 0.2078431373, green: 0.9176470588, blue: 0.8901960784, alpha: 1)
        nextButton.bottomColor = #colorLiteral(red: 0.6588235294, green: 0.2784313725, blue: 1, alpha: 1)
        
    }
}

