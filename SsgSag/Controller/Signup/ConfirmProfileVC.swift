//
//  ConfirmProfileVC.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 10..
//  Copyright © 2019년 wndzlf. All rights reserved.
//

import UIKit

class ConfirmProfileVC: UIViewController {
    
    private var gender = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var birthField: UITextField!
    
    @IBOutlet weak var nickNameField: UITextField!
    
    @IBOutlet weak var maleButton: UIButton!
    
    @IBOutlet weak var femaleButton: UIButton!
    
    @IBOutlet weak var checkBoxButton: UIButton!
    
    @IBOutlet weak var nextButton: GradientButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBar(color: .white)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iniGestureRecognizer()
        setupDelegate()
    }
    
    private func iniGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(handleTabMainView(_:)))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    private func setupDelegate() {
        nameField.delegate = self
        birthField.delegate = self
        nickNameField.delegate = self
    }
    
    @objc private func handleTabMainView(_ sender: UITapGestureRecognizer) {
        nameField.resignFirstResponder()
        nickNameField.resignFirstResponder()
        birthField.resignFirstResponder()
    }
    
    @objc func checkInformation() {
        guard nameField.hasText
            && birthField.hasText
            && nickNameField.hasText
            && checkBoxButton.isSelected else {
                
                nextButton.isUserInteractionEnabled = false
                
                nextButton.topColor = .lightGray
                nextButton.bottomColor = .lightGray
                
                return
        }
        
        guard maleButton.isSelected || femaleButton.isSelected else {
            nextButton.isUserInteractionEnabled = false
            
            nextButton.topColor = .lightGray
            nextButton.bottomColor = .lightGray
            
            return
        }
        
        nextButton.isUserInteractionEnabled = true
        
        nextButton.topColor = #colorLiteral(red: 0.2078431373, green: 0.9176470588, blue: 0.8901960784, alpha: 1)
        nextButton.bottomColor = #colorLiteral(red: 0.6588235294, green: 0.2784313725, blue: 1, alpha: 1)
        
    }
    
    // 이용약관 표시
    @IBAction private func privatePolicyInfomation(_ sender: Any) {
        let storyboard = UIStoryboard(name: StoryBoardName.signup,
                                      bundle: nil)
        let termsOfServiceViewController
            = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.termsOfServiceViewController)
        
        navigationController?.pushViewController(termsOfServiceViewController,
                                                 animated: true)
    }
    
    private func isValidateName(name: String?) -> Bool {
        guard name != nil else { return false }
        
        let englishRegEx = "^[a-zA-Z]{1,10}$"
        let koreanRegEx = "^[가-힣]{1,10}$"
        
        let englishPred = NSPredicate(format: "SELF MATCHES %@", englishRegEx)
        let koreanPred = NSPredicate(format: "SELF MATCHES %@", koreanRegEx)
        
        return englishPred.evaluate(with: name) || koreanPred.evaluate(with: name)
    }
    
    private func isValidateBirth(birth: String?) -> Bool {
        guard birth != nil else { return false }
        
        let regEx = "^(?:[0-9]{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[1,2][0-9]|3[0,1]))$"
        
        let pred = NSPredicate(format: "SELF MATCHES %@", regEx)
        
        return pred.evaluate(with: birth)
    }
    
    private func isValidateNickName(nickName: String?) -> Bool {
        guard nickName != nil else { return false }
        
        let regEx = "^[a-zA-Z가-힣0-9]{1,10}$"
        
        let pred = NSPredicate(format: "SELF MATCHES %@", regEx)
        
        return pred.evaluate(with: nickName)
    }
    
    @IBAction func touchUpNextButton(_ sender: Any) {
        
        guard isValidateName(name: nameField.text) else {
            simpleAlert(title: "잘못된 형식입니다",
                        message: "이름은 영문자 또는 한글만 입력할 수 있습니다. (혼용X)")
            nameField.text = ""
            
            nextButton.isUserInteractionEnabled = false
            
            nextButton.topColor = .lightGray
            nextButton.bottomColor = .lightGray
            return
        }
        
        guard isValidateBirth(birth: birthField.text) else {
            simpleAlert(title: "잘못된 형식입니다",
                        message: "생년월일(주민번호 앞자리) 형식이 잘못되었습니다.")
            birthField.text = ""
            
            nextButton.isUserInteractionEnabled = false
            
            nextButton.topColor = .lightGray
            nextButton.bottomColor = .lightGray
            return
        }
        
        guard isValidateNickName(nickName: nickNameField.text) else {
            simpleAlert(title: "잘못된 형식입니다",
                        message: "닉네임은 1~10자 영문자, 한글, 숫자 조합으로 입력해주세요")
            nickNameField.text = ""
            
            nextButton.isUserInteractionEnabled = false
            
            nextButton.topColor = .lightGray
            nextButton.bottomColor = .lightGray
            return
        }
        
        let storyboard = UIStoryboard(name: StoryBoardName.signup, bundle: nil)
        let SchoolInfoVC
            = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.schoolInfoViewController)
                as! SchoolInfoVC
        
        SchoolInfoVC.name = nameField.text ?? ""
        SchoolInfoVC.birth = birthField.text ?? ""
        SchoolInfoVC.nickName = nickNameField.text ?? ""
        SchoolInfoVC.gender = gender
        
        navigationController?.pushViewController(SchoolInfoVC, animated: true)
    }
    
    @IBAction func touchUpMaleButton(_ sender: UIButton) {
        femaleButton.isSelected = false
        femaleButton.setImage(UIImage(named: "btFemaleUnactive"), for: .normal)
        if maleButton.isSelected {
            gender = ""
            maleButton.isSelected = false
            maleButton.setImage(UIImage(named: "btMaleUnactive"), for: .normal)
        } else {
            gender = "male"
            maleButton.isSelected = true
            maleButton.setImage(UIImage(named: "btMaleActive"), for: .normal)
        }
        checkInformation()
    }
    
    @IBAction func touchUpFemaleButton(_ sender: UIButton) {
        maleButton.isSelected = false
        maleButton.setImage(UIImage(named: "btMaleUnactive"),
                            for: .normal)
        
        if femaleButton.isSelected {
            gender = ""
            femaleButton.isSelected = false
            femaleButton.setImage(UIImage(named: "btFemaleUnactive"),
                                  for: .normal)
        } else {
            gender = "female"
            femaleButton.isSelected = true
            femaleButton.setImage(UIImage(named: "btFemaleActive"),
                                  for: .normal)
        }
        
        checkInformation()
    }
    
    @IBAction func touchUpCheckBoxButton(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            sender.setImage(UIImage(named: "btCheckUnactive"), for: .normal)
        } else {
            sender.isSelected = true
            sender.setImage(UIImage(named: "btCheckActive"), for: .normal)
        }
        checkInformation()
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        checkInformation(self)
//    }
}

extension ConfirmProfileVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let nextTag = textField.tag + 1
        
        if let nextResponder = self.view.viewWithTag(nextTag) {
            
            nextResponder.becomeFirstResponder()
            
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkInformation()
    }
}

extension ConfirmProfileVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
