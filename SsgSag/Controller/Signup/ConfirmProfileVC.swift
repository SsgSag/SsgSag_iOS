//
//  ConfirmProfileVC.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 10..
//  Copyright © 2019년 wndzlf. All rights reserved.
//

import UIKit

class ConfirmProfileVC: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    private var gender = ""
    
    private var isEnglish = false
    
    private var isKorean = false
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var birthField: UITextField!
    
    @IBOutlet weak var nickNameField: UITextField!
    
    @IBOutlet weak var maleButton: UIButton!
    
    @IBOutlet weak var femaleButton: UIButton!
    
    @IBOutlet weak var checkBoxButton: UIButton!
    
    @IBOutlet weak var nextButton: GradientButton!
    
    override func viewWillAppear(_ animated: Bool) {
        let backButton = UIBarButtonItem(image: UIImage(named: "ic_ArrowBack"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(self.back))
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.isUserInteractionEnabled = false
        
        iniGestureRecognizer()
        
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
    
    @objc func back(){
        dismiss(animated: true)
//        let storyboard = UIStoryboard(name: StoryBoardName.login, bundle: nil)
//        let loginVC = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.loginViewController)
//        present(loginVC, animated: false, completion: nil)
    }
    
    // 이용약관 표시
    @IBAction func privatePolicyInfomation(_ sender: Any) {
        let storyboard = UIStoryboard(name: StoryBoardName.signup, bundle: nil)
        let termsOfServiceViewController = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.termsOfServiceViewController)
        self.navigationController?.pushViewController(termsOfServiceViewController, animated: true)
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
        let name = nameField.text ?? ""
        
        if name.count < 11, name.count > 0 {
            name.forEach {
                if $0 >= "가" && $0 <= "힣" {
                    isKorean = true
                } else {
                    isKorean = false
                }
            }
            name.forEach {
                if ($0 >= "a" && $0 <= "z") || ($0 >= "A" && $0 <= "Z") {
                    isEnglish = true
                } else {
                    isEnglish = false
                }
            }
                
            if isEnglish && isKorean {
                // alert
                simpleAlert(title: "잘못된 형식입니다", message: "이름은 영문자 또는 한글만 입력할 수 있습니다. (혼용X)")
                nameField.text = ""
                isEnglish = false
                isKorean = false
                return
            }
        } else {
            // alert
            simpleAlert(title: "잘못된 형식입니다", message: "이름은 영문자 또는 한글만 입력할 수 있습니다. (혼용X)")
            nameField.text = ""
            isEnglish = false
            isKorean = false
            return
        }
        
        let birth = birthField.text ?? ""
        
        if birth.count == 6 {
            birth.forEach {
                if !($0 >= "0" && $0 <= "9") {
                    // alert
                    simpleAlert(title: "잘못된 형식입니다", message: "생년월일(주민번호 앞자리) 형식이 잘못되었습니다.")
                    birthField.text = ""
                    return
                }
            }
        } else {
            simpleAlert(title: "잘못된 형식입니다", message: "생년월일(주민번호 앞자리) 형식이 잘못되었습니다.")
            birthField.text = ""
            return
        }
        
        let nickName = nickNameField.text ?? ""
        
        if nickName.count < 11, nickName.count > 0 {
            name.forEach {
                if !(($0 >= "가" && $0 <= "힣") || ($0 >= "a" && $0 <= "z") || ($0 >= "A" && $0 <= "Z") || ($0 >= "0" && $0 <= "9")) {
                    // alert
                    simpleAlert(title: "잘못된 형식입니다", message: "닉네임은 1~10자 영문자, 한글, 숫자 조합으로 입력해주세요")
                    nickNameField.text = ""
                    return
                }
            }
            
        } else {
            // alert
            simpleAlert(title: "잘못된 형식입니다", message: "닉네임은 1~10자 영문자, 한글, 숫자 조합으로 입력해주세요")
            nickNameField.text = ""
            return
        }
        
        let storyboard = UIStoryboard(name: StoryBoardName.signup, bundle: nil)
        let SchoolInfoVC = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.schoolInfoViewController) as! SchoolInfoVC
        
        SchoolInfoVC.name = nameField.text ?? ""
        SchoolInfoVC.birth = birthField.text ?? ""
        SchoolInfoVC.nickName = nickNameField.text ?? ""
        SchoolInfoVC.gender = gender
        
        self.navigationController?.pushViewController(SchoolInfoVC, animated: true)
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

