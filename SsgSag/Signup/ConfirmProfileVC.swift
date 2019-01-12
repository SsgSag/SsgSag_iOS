//
//  ConfirmProfileVC.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 10..
//  Copyright © 2019년 wndzlf. All rights reserved.
//

import UIKit

class ConfirmProfileVC: UIViewController {
    
    var id: String = ""
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
        iniGestureRecognizer()
        self.titleLabel.isHidden = false
        self.titleImage.isHidden = false
        self.navigationItem.setHidesBackButton(true, animated: true)
        setBackBtn( color: .black)
        setNavigationBar(color: .white)
    }
    

    @IBAction func touchUpNextButton(_ sender: Any) {
        
        
    }
    
    @IBAction func touchUpMaleButton(_ sender: UIButton) {
        femaleButton.isSelected = false
        femaleButton.setImage(UIImage(named: "btFemaleUnactive"), for: .normal)
        if maleButton.isSelected {
            self.gender = "male"
            maleButton.isUserInteractionEnabled = false
            maleButton.setImage(UIImage(named: "btMaleUnactive"), for: .normal)
        } else {
            self.gender = "female"
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
            self.gender = "male"
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterForKeyboardNotifications()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navVC = segue.destination as! SchoolInfoVC
        navVC.id = id
        navVC.password = password
        navVC.name = nameField.text ?? ""
        navVC.birth = birthField.text ?? ""
        navVC.nickName = nickNameField.text ?? ""
        navVC.gender = gender
        
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
    
//    func textField
    
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

extension ConfirmProfileVC : UIGestureRecognizerDelegate {
    
    func iniGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTabMainView(_:)))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTabMainView(_ sender: UITapGestureRecognizer){
        self.nameField.resignFirstResponder()
        self.birthField.resignFirstResponder()
        self.nickNameField.resignFirstResponder()
    }
    
    //터치가 먹히는 상황과 안먹히는 상황
    private func gestureRecog(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: nameField))! || (touch.view?.isDescendant(of: birthField))! || (touch.view?.isDescendant(of: nickNameField))! {
            return false
        }
        return true
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {return}
        //IOS자체에 애니메이션을 담당해주는 역할. animation을 이용하면 이쁘게 뷰를 꾸밀 수 있다.
        //되게 간단하다.
        //애니메이션 실행 시간 duration , delay는 몇초뒤에 실행할 건지, springwithDamping: 움직일때 떠린다거 나 그런 옵션, initiaon springvelocity -> 가속도 , options ---> curveEaseInOut등등, 을 많이 씀. 이동하거나 크기가 변화 시키는 값을 줄때 curveLinear , completion은 애니매이션이 끝났을때 해주는 것
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: { [unowned self] in
            print("현재 constraint: \(self.stackViewConstraint.constant)")
            self.stackViewConstraint.constant = 10
            self.titleImage.isHidden = true
            self.titleLabel.isHidden = true
//            let alpha: CGFloat = 0.5
//            self.titleImage.alpha(alpha)
//            self.titleImage.opa
            
        })
        stackViewConstraint.constant = 120
        self.view.layoutIfNeeded()
        
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {return}
        //여기서는 weak self를 안쓰는 이유?는?
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
            self.stackViewConstraint.constant = 289
            print(" constraint: \(self.stackViewConstraint.constant)")
            self.titleLabel.isHidden = false
            self.titleImage.isHidden = false
            
        })
        stackViewConstraint.constant = 289
        self.view.layoutIfNeeded()
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension UIImage {
    
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
